# -*- coding: utf-8 -*-
import locale
import os
import shutil
import sys
from abc import abstractmethod
from enum import Enum
from typing import Dict, List, Optional

from PyQt5.QtCore import (QDateTime, QDir, QFile, Qt, QThread,
                          pyqtSignal)
from PyQt5.QtGui import QColor, QFont, QIcon, QStandardItem, QStandardItemModel
from PyQt5.QtWidgets import (QApplication, QHBoxLayout, QLabel, QProgressBar,
                             QPushButton, QSizePolicy, QTableView, QTextEdit,
                             QVBoxLayout, QWidget)

from process_exception import ProcessException


class DownloadedFile:
    """Support class for handling the download"""
    name: str
    size: float
    creationDate: float
    updateDate: QDateTime
    specialSubFolder: str = None

    def __init__(self, name: str, size: float, updateDate: float) -> None:
        self.name = name
        self.size = size
        self.updateDate = QDateTime.fromSecsSinceEpoch(int(updateDate))


class Status(Enum):
    """ Status for the messages """
    NORMAL = "black"
    UPDATED = "green"
    ERROR = "red"
    UPDATED_VIEW = "green"


class MoFa4QSync(QWidget):
    """Main class showing QWidget with a list of all updatable files"""
    DEFAULT_COMPANY = "wheregroup"
    SERVER_DEV_FOLDER = "/srv/fake_server"
    SERVER_FOLDER_WIN = "\\\\Fake_Server\\download\\data"
    INSTALL_PATH = "C:/MoFa4Q"
    GPKG_FOLDER_WIN = "C:/MoFa4Q/profiles/MoFa4Q/geopackages/public"
    ADDRESS_GEOPACKAGE = "addresses.gpkg"
    GEOSEARCH_GEOPACKAGE = "search_objects.gpkg"
    AERIALPHOTO_GEOPACKAGE = "dop.gpkg"
    TIME_FORMAT = "yyyy-MM-dd HH:mm:ss"
    TIMESTAMP_FILE = "_tmstmp.txt"
    TITLE = "Synchronisierung - GeoPackages"
    INIT_MSG = ("Dieses Programm aktualisiert und lädt alle GeoPackages herunter. "
                "\nDateien in rot markiert sind für Luftbilder.")
    STOP_MSG = "Der Download wurde gestoppt."
    UPDATED_MSG = "  ist aktuell"
    DOP_MSG = "Luftbilder - ACHTUNG! Download ist aufwändig"
    WIDTH = 900
    HEIGHT = 650
    COL_0 = 370
    COL_1 = 100
    COL_2 = 180
    COL_3 = 180
    runThread = None
    downloadableList: List[DownloadedFile] = []
    selFiles = []

    def __init__(self, inputInstallMofa4QPath: Optional[str]=None, inputProfilePath: Optional[str]=None, inputCompany: Optional[str]=None,
                 inputServerFolder: Optional[str] = None):
        super().__init__()
        locale.setlocale(locale.LC_ALL, '')
        self.installPath = inputInstallMofa4QPath if inputInstallMofa4QPath else self.INSTALL_PATH
        self.gpkgFolder = os.path.join(inputProfilePath, 'geopackages\public') if inputProfilePath else self.GPKG_FOLDER_WIN
        self.company = inputCompany if inputCompany is not None else self.DEFAULT_COMPANY
        self.title = "{0} - {1}".format(self.TITLE, self.company)
        self.width = self.WIDTH
        self.height = self.HEIGHT
        
        self.serverFolder = inputServerFolder
        # check WIN OS
        if os.name == 'nt':
            print("Works in windows (Setting for client is used).")
            self.isWindows = True
            if not self.serverFolder:
                self.serverFolder = self.SERVER_FOLDER_WIN
        else:
            self.isWindows = False
            if not self.serverFolder:
                self.serverFolder = self.SERVER_DEV_FOLDER

        self.initUI()

    def initUI(self):

        self.setWindowTitle(self.title)

        self.msg = QLabel(self.INIT_MSG, self)
        self.msg.setWordWrap(True)

        self.tableView: QTableView = QTableView()
        model: QStandardItemModel = QStandardItemModel()
        model.setHorizontalHeaderLabels([self.tr('Dateiname'), self.tr('Größe'), self.tr('Letzte Änderung Lokal'), 
                                        self.tr('Letzte Änderung Server')])
        self.tableView.setModel(model)
        model.itemChanged.connect(self.stateChanged)
        self.tableView.setColumnWidth(0, self.COL_0)
        self.tableView.setColumnWidth(1, self.COL_1)
        self.tableView.setColumnWidth(2, self.COL_2)
        self.tableView.setColumnWidth(3, self.COL_3)

        self.textProtocol = QTextEdit()

        self.progressBar = QProgressBar()

        self.btn1 = QPushButton("Download starten", self)
        self.btn1.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        self.btn1.clicked.connect(self.runDownload)
        self.btn2 = QPushButton("Stoppen", self)
        self.btn2.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        self.btn2.clicked.connect(self.stopProcess)
        self.btn3 = QPushButton("Beenden", self)
        self.btn3.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
        self.btn3.clicked.connect(self.closeDialog)

        hLayout = QHBoxLayout()
        hLayout.addWidget(self.btn1, 1)
        hLayout.addWidget(self.btn2, 0)
        hLayout.addWidget(self.btn3, 0)

        layout = QVBoxLayout()
        layout.addWidget(self.msg)
        layout.addWidget(self.tableView)
        layout.addWidget(self.textProtocol)
        layout.addWidget(self.progressBar)
        layout.addLayout(hLayout)
        self.setLayout(layout)

        desktopRect = QApplication.desktop().availableGeometry()
        center = desktopRect.center()

        self.setGeometry(int(center.x() - self.width * 0.5),
                         int(center.y() - self.height * 0.5), self.width, self.height)
        self.show()

        try:
            self.createList(model)
        except FileNotFoundError as e:
            self.reportInfo("Keine Verbindung zum Server oder Resource nicht gefunden: {} {}"
                            .format(self.serverFolder, str(e)), Status.ERROR)
        except PermissionError as e:
            self.reportInfo("Keine Verbindung zum Server: {} {}".format(self.serverFolder, str(e)), Status.ERROR)
        except Exception as e:
            self.reportInfo("Unbekannter Fehler: {}".format(str(e)), Status.ERROR)

    def copyLargeFile(self, src, dest, buffer_size=16000):
        with open(src, 'rb') as fsrc:
            with open(dest, 'wb') as fdest:
                # it seems it is not necessary
                shutil.copyfileobj(fsrc, fdest, buffer_size)
                pass

    def createList(self, model: QStandardItemModel):
        rowCount = -1
        dopGpkg: Optional[DownloadedFile] = None
        fileEntry: os.DirEntry
        for fileEntry in os.scandir(self.serverFolder):
            if fileEntry.name.endswith(".gpkg") or fileEntry.name.endswith(".qlr") or fileEntry.name == "sequence_qlr.yml":
                dFile = DownloadedFile(fileEntry.name, fileEntry.stat().st_size, fileEntry.stat().st_mtime)
                if dFile.name == self.ADDRESS_GEOPACKAGE or dFile.name == self.GEOSEARCH_GEOPACKAGE:
                    dFile.specialSubFolder = "../search"
                if dFile.name == self.AERIALPHOTO_GEOPACKAGE:
                    dFile.specialSubFolder = "../dop"
                    dopGpkg = dFile
                else:
                    rowCount += 1
                    self.downloadableList.append(dFile)
                    self.addRow(dFile, rowCount, model)

        if dopGpkg:
            rowCount += 1
            self.downloadableList.append(dopGpkg)
            self.addRow(dopGpkg, rowCount, model)

    def reportInfo(self, txt: str, status: Status):
        """ Sends a info in the protocol """
        if status is Status.NORMAL:
            self.textProtocol.setTextColor(QColor("black"))
        elif status is Status.UPDATED or status is Status.UPDATED_VIEW:
            self.textProtocol.setTextColor(QColor("green"))
        elif status is Status.ERROR:
            self.textProtocol.setTextColor(QColor("red"))
        now = QDateTime.currentDateTime()
        if txt != "":
            txt = "{} - {}".format(now.toString(self.TIME_FORMAT), txt)
        self.textProtocol.append(txt)
        self.printLogFile()

    def printLogFile(self):
        """ Sends a info in the protocol """
        protocol = self.textProtocol.toPlainText()
        logfile_path = os.path.split(self.gpkgFolder)[0]
        # print(protocol)
        f = open(os.path.join(logfile_path, "protocol.txt"), "w")
        f.write(protocol)
        f.close()

    def runDownload(self):
        self.textProtocol.clear()
        self.runThread = RunThread(self.isWindows, self.company, self.selFiles, self.downloadableList,
                                   self.serverFolder, self.TIME_FORMAT,
                                   self.gpkgFolder, self.TIMESTAMP_FILE)
        self.runThread.signalStatus.connect(self.reportInfo)
        self.runThread.signalBtnEnabled.connect(self.setBtnDisabled)
        self.runThread.signalProgressBar.connect(self.setProgressBar)
        self.runThread.start()

    def setBtnDisabled(self, isEnabled: bool):
        self.btn1.setEnabled(isEnabled)

    def stopProcess(self):
        if self.runThread and self.runThread.running:
            self.runThread.running = False
            self.reportInfo(self.STOP_MSG, Status.ERROR)

    def setProgressBar(self, value: int):
        """ Handles progress bar """
        self.progressBar.setValue(value)

    def closeDialog(self):
        self.stopProcess()
        self.close()

    def addRow(self, dFile: DownloadedFile, rowCount: int, model: QStandardItemModel):
        locFile = self.isFileUpdated(dFile)
        item1 = QStandardItem(dFile.name + (self.UPDATED_MSG if locFile.get("isUp") else ""))
        item1.setCheckable(True)
        item1.setEnabled(not locFile.get("isUp"))
        item2 = QStandardItem("{:.1f} MB".format(dFile.size / 1000000))
        item3 = QStandardItem(QDateTime.toString(
            locFile.get("date"), self.TIME_FORMAT) if locFile.get("date") else "")
        item4 = QStandardItem(QDateTime.toString(dFile.updateDate, self.TIME_FORMAT))

        if dFile.specialSubFolder:
            f = QFont()
            # f.setItalic(True)
            item1.setFont(f)
            if dFile.specialSubFolder == "../dop":
                item2.setText('ca. {:.1f} GB'.format(round(dFile.size / 100000000) / 10)),  # GB
                item1.setForeground(QColor("red"))
                if locFile.get("isUp") is False:
                    item1.setText(self.DOP_MSG)
                else:
                    item1.setText("Luftbilder - " + self.UPDATED_MSG)

        model.setItem(rowCount, 0, item1)
        model.setItem(rowCount, 1, item2)
        model.setItem(rowCount, 2, item3)
        model.setItem(rowCount, 3, item4)

        if locFile.get("isUp") is not True and dFile.name != self.AERIALPHOTO_GEOPACKAGE:
            item1.setCheckState(Qt.Checked)
        else:
            item1.setCheckState(Qt.Unchecked)

    def isFileUpdated(self, dFile: DownloadedFile) -> dict[bool, QDateTime]:
        """
        Checks if date on the server is more recent than the local geopackage
        The method toTime_t() is used: it returns the datetime as the number
        of seconds that have passed since 1970-01-01T00:00:00,
        Coordinated Universal Time (Qt.UTC).
        For special cases (addresses, dop etc.) will be used a special file (timestamp) to make the comparison
        """
        locFile: str = os.path.join(self.gpkgFolder,
                                    str(dFile.specialSubFolder or ''), dFile.name)
        tmstmpFile: str = os.path.splitext(locFile)[0] + self.TIMESTAMP_FILE

        # special case for qlr
        if os.path.splitext(locFile)[1] == '.qlr':
            tmstmpFile: str = os.path.splitext(locFile)[0] + '_qlr' + self.TIMESTAMP_FILE

        if QFile.exists(tmstmpFile):
            f = open(tmstmpFile, "r")
            updatedDate: QDateTime = QDateTime.fromString(f.readline(), self.TIME_FORMAT)
            if updatedDate.toString() == "":
                return {"isUp": False, "date": None}
        else:
            return {"isUp": False, "date": None}

        if dFile.updateDate.toTime_t() == updatedDate.toTime_t():
            # print('updatedDate is actual', updatedDate)
            return {"isUp": True, "date": updatedDate}
        return {"isUp": False, "date": updatedDate}

    def stateChanged(self, item: QStandardItem) -> None:
        if item.checkState() == Qt.Checked:
            self.selFiles.append(item.row())
        elif item.row() in self.selFiles:
            self.selFiles.remove(item.row())


class WorkerThread(QThread):
    """ Abstract class for Thread, Definition general methods """
    running: bool = False

    def __init__(self):
        QThread.__init__(self)

    @abstractmethod
    def run(self):  # start()  starts run
        if self.running is False:
            self.running = True
            self.doWork()

    @abstractmethod
    def stop(self):
        self.running = False

    @abstractmethod
    def doWork(self):
        return True

    @abstractmethod
    def cleanUp(self):
        pass


class RunThread(WorkerThread):
    """ Implementation of the class WorkerThread """
    SUCCESS_MSG = "Der Download wurde erfolgreich abgeschlossen."
    FAILURE_MSG = "Der Download wurde nicht erfolgreich abgeschlossen."
    START_MSG = "Download gestartet. Der Vorgang kann lange dauern"
    MB_MSG = "{} Dateien mit insgesamt {:.1f} MB \n"
    FILE_DOWNLOAD_MSG = "File {} wird herunterladen..."
    COMPLETE_MSG = "     Datei {} wurde heruntergeladen"
    MAX_PARTIAL_DOWNLOAD = 10

    signalStatus = pyqtSignal(str, Status)
    signalBtnEnabled = pyqtSignal(bool)
    signalProgressBar = pyqtSignal(int)

    def __init__(self, isWindows: bool, company: str, selFiles: List[int], downloadableList: List[DownloadedFile],
                 serverFolder: str, timeFormat: str, folder: str, timestampFile: str):
        WorkerThread.__init__(self)
        self.SERVER_FOLDER = serverFolder
        self.TIME_FORMAT = timeFormat
        self.GPKG_FOLDER = folder
        self.TIMESTAMP_FILE = timestampFile
        self.isWindows = isWindows
        self.company = company
        self.selFiles: List[int] = selFiles
        self.downloadableList: List[DownloadedFile] = downloadableList
        # print("self.company", self.company)

    def doWork(self):
        try:
            print("START......................................")
            # remove the folder search or addresses (old implementation of the search) if exists
            exDir = QDir(os.path.join(self.GPKG_FOLDER, "search"))
            if exDir.exists():
                exDir.removeRecursively()
            exDir = QDir(os.path.join(self.GPKG_FOLDER, "addresses"))
            if exDir.exists():
                exDir.removeRecursively()

            self.signalProgressBar.emit(0)
            self.signalBtnEnabled.emit(False)
            totalMb = 0
            selFiles2: List[DownloadedFile] = []
            for rowCount in range(0, len(self.downloadableList)):
                if rowCount in self.selFiles:
                    selFiles2.append(self.downloadableList[rowCount])
                    totalMb += self.downloadableList[rowCount].size

            self.downloadSelGpkgs(selFiles2, totalMb)

            self.signalStatus.emit("", Status.NORMAL)
            if self.running:
                self.signalStatus.emit(self.SUCCESS_MSG, Status.UPDATED)
            else:
                self.signalStatus.emit(self.FAILURE_MSG, Status.ERROR)

            print("END......................................")

        except ProcessException as e:
            self.signalStatus.emit(
                "Der Prozess wurde beendet: " + str(e), Status.ERROR)
        finally:
            self.signalBtnEnabled.emit(True)
            self.signalProgressBar.emit(100)
            self.running = False

    def downloadSelGpkgs(self, downloadableList: List[DownloadedFile], totalMb: float):
        fileCount = len(downloadableList)
        actualSize = 0
        self.signalStatus.emit("", Status.NORMAL)
        self.signalStatus.emit(self.START_MSG, Status.NORMAL)
        self.signalStatus.emit(self.MB_MSG.format(
            fileCount, totalMb / 1000000), Status.NORMAL)
        dFile: DownloadedFile
        for dFile in downloadableList:
            if self.running is False:
                # stop everything, go out
                break
            if not dFile.specialSubFolder:
                self.getDownloadFile(dFile, actualSize + dFile.size, totalMb, "", "")
            else:
                self.specialDownload(dFile, actualSize + dFile.size, totalMb)

            actualSize += dFile.size

    def specialDownload(self, dFile: DownloadedFile, actualSize: float, totalMb: float):
        self.getDownloadFile(dFile, actualSize, totalMb, "", dFile.specialSubFolder)

    def getDownloadFile(self, dFile: DownloadedFile, newSize: float, totalMb: float, subFolderServer: str,
                        subFolderLoc: str):
        # print(dFile, subFolderServer, subFolderLoc, newSize, totalMb)
        self.signalStatus.emit(self.FILE_DOWNLOAD_MSG.format(dFile.name), Status.NORMAL)
        localFolder = os.path.join(self.GPKG_FOLDER, subFolderLoc)
        if not QDir(localFolder).exists():
            QDir().mkdir(localFolder)

        # time.sleep(4)
        locFilePath: str = os.path.join(localFolder, dFile.name)
        title: str = ""

        self.downloader(subFolderServer, dFile.name, locFilePath)

        if QFile.exists(locFilePath + ".tmp"):
            QFile(locFilePath).remove()
            QFile(locFilePath + ".tmp").rename(locFilePath)
        # print("newSize", "totalMb", newSize, totalMb, newSize / totalMb * 99)
        self.signalProgressBar.emit(int(newSize / totalMb * 99))
        if not title or title == dFile.name:
            title = ""
        else:
            title = "- " + title + " "
        if self.running:
            self.signalStatus.emit(self.COMPLETE_MSG.format(dFile.name, title), Status.UPDATED_VIEW)

        self.createTimestampFile(dFile.updateDate, locFilePath)
        return locFilePath

    def downloader(self, subFolderServer: str, filename: str, dFile: str):
        buffer_size = 16 * 16 * 1024
        src = self.SERVER_FOLDER + "/" + subFolderServer + "/" + filename
        with open(src, 'rb') as fsrc:
            with open(dFile + ".tmp", 'wb') as fdest:
                shutil.copyfileobj(fsrc, fdest, buffer_size)

    def createTimestampFile(self, updatedDate: QDateTime, dFile: str):
        """ Create an empty text file with last download in the file """

        fileName: str = os.path.splitext(dFile)[0] + self.TIMESTAMP_FILE
        if os.path.splitext(dFile)[1] == '.qlr':  # special case for qlr
            fileName: str = os.path.splitext(dFile)[0] + '_qlr' + self.TIMESTAMP_FILE
        with open(fileName, "w") as timestamp:          
            timestamp.write(QDateTime.toString(updatedDate, self.TIME_FORMAT))


if __name__ == '__main__':
    inputArg1 = sys.argv[1] if sys.argv[1:] else None
    inputArg2 = sys.argv[2] if sys.argv[2:] else None
    inputArg3 = sys.argv[3] if sys.argv[3:] else None
    inputArg4 = sys.argv[4] if sys.argv[4:] else None
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon(os.path.dirname(os.path.dirname(os.path.abspath(__file__))) + "/icons/mops_sync_public.ico"))
    #print(inputArg1, inputArg2, inputArg3, inputArg4)
    ex = MoFa4QSync(inputArg1, inputArg2, inputArg3, inputArg4)
    sys.exit(app.exec_())
