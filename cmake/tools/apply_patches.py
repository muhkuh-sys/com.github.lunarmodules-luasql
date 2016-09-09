import logging
import os
import os.path
import patch


def apply_diffs(strWorkingFolder, strPatchFolder, uiStrip):
    # Collect all ".diff" files from the patch folder.
    astrPatches = []
    for strDirname, astrDirnames, astrFilenames in os.walk(strPatchFolder):
        for strFilename in astrFilenames:
            strDummy, strExt = os.path.splitext(strFilename)
            if strExt == '.diff':
                strAbsFilename = os.path.join(strDirname, strFilename)
                astrPatches.append(strAbsFilename)

    # Sort the patches alphabetically.
    astrSortedPatches = sorted(astrPatches)
    for strPatch in astrSortedPatches:
        print 'Apply patch "%s"...' % strPatch

        # Apply the patches.
        tPatch = patch.fromfile(strPatch)
        tPatch.diffstat()
        tPatch.apply(uiStrip, root=strWorkingFolder)


def __copy_file(strSource, strDestination):
    # Copy the data in chunks of 4096 bytes.
    sizChunk = 4096

    # Open the files.
    tFileSrc = open(strSource, 'rb')
    tFileDst = open(strDestination, 'wb')

    # Copy the data in chunks of 4096 bytes.
    fEof = False
    while fEof is False:
        strData = tFileSrc.read(sizChunk)
        tFileDst.write(sizChunk)
        if len(strData) < sizChunk:
            fEof = True


def copy_files(strWorkingFolder, strCopyFolder):
    for strDirname, astrDirnames, astrFilenames in os.walk(strCopyFolder):
        # Get the path from the start folder to the current folder.
        strCurrentRelPath = os.path.relpath(strDirname, strCopyFolder)

        strWorkingSubFolder = os.path.join(strWorkingFolder, strCurrentRelPath)

        # Create the current subfolder in the working folder.
        if os.path.exist(strWorkingSubFolder) != True:
            print 'Create folder "%s".' % strWorkingSubFolder
            os.mkdir(strWorkingSubFolder)

        # Copy all files in the folder.
        for strFilename in astrFilenames:
            strSourceFile = os.path.join(strDirname, strFilename)
            strDestinationFile = os.path.join(strWorkingSubFolder,
                                              strCurrentRelPath,
                                              strFilename)
            print 'Copy file "%s" -> "%s".' % (strSourceFile,
                                               strDestinationFile)
            __copy_file(strSourceFile, strDestinationFile)


def main():
    import argparse

    tParser = argparse.ArgumentParser(
        description='Apply diffs and copy files to patch a source tree.')
    tParser.add_argument(
        '-w', '--working-folder',
        dest='strWorkingFolder',
        required=True,
        help='use PATH as the working folder',
        metavar='PATH'
    )
    tParser.add_argument(
        '-p', '--patch-folder',
        dest='strPatchFolder',
        required=False,
        default=None,
        help='scan PATH for .diff files and apply them to the working folder',
        metavar='PATH'
    )
    tParser.add_argument(
        '-c', '--copy-folder',
        dest='strCopyFolder',
        required=False,
        default=None,
        help='copy the contents of PATH recursively over the working folder',
        metavar='PATH'
    )
    tParser.add_argument(
        '-s', '--strip',
        dest='uiStrip',
        required=False,
        default=0,
        metavar='N',
        type=int,
        help='strip N levels from the paths in all patch files'
    )
    aOptions = tParser.parse_args()

    print 'Using patch %s by %s.' % (patch.__version__, patch.__author__)

    # verbosity levels = logging.WARNING, logging.INFO, logging.DEBUG
    logformat = "%(message)s"
    patch.logger.setLevel(logging.DEBUG)
    patch.streamhandler.setFormatter(logging.Formatter(logformat))
    patch.setdebug()

    # Check if the working folder exists.
    if os.path.exists(aOptions.strWorkingFolder) != True:
        raise Exception(
            'The working folder "%s" does not exist or is not accessible.' %
            aOptions.strWorkingFolder
        )
    if os.path.isdir(aOptions.strWorkingFolder) != True:
        raise Exception(
            'The working folder "%s" is no folder.' %
            aOptions.strWorkingFolder
        )

    # Is the patch folder defined?
    if aOptions.strPatchFolder is not None:
        if os.path.exists(aOptions.strPatchFolder) != True:
            raise Exception(
                'The patch folder "%s" does not exist or is not accessible.' %
                aOptions.strPatchFolder
            )
        if os.path.isdir(aOptions.strPatchFolder) != True:
            raise Exception(
                'The patch folder "%s" is no folder.' %
                aOptions.strPatchFolder
            )

        apply_diffs(aOptions.strWorkingFolder,
                    aOptions.strPatchFolder,
                    aOptions.uiStrip)

    # Is the copy folder defined?
    if aOptions.strCopyFolder is not None:
        if os.path.exists(aOptions.strCopyFolder) != True:
            raise Exception(
                'The copy folder "%s" does not exist or is not accessible.' %
                aOptions.strCopyFolder
            )
        if os.path.isdir(aOptions.strCopyFolder) != True:
            raise Exception(
                'The patch folder "%s" is no folder.' %
                aOptions.strCopyFolder
            )

        copy_files(aOptions.strWorkingFolder, aOptions.strCopyFolder)


if __name__ == "__main__":
    main()
