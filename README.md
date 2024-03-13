# SynchFiles

This script aims to complete a one-way Synchronization between folders source and replica.
Passing 3 parameters to the script, the source folder directory, the replica folder directory and the log text file directory, the script will turn the replica folder into an exact copy of the source folder.
The order of the parameters are as it follows: Synch -Source $SourceFolder -Replica $ReplicaFolder -Log $Log.txt
This script also has a deletion mechanism, for example if a file is on the replica folder ( due to past synchs ) but is no longer present in the source folder, the script will notify that the file X is no longer in the source material, and ask if its supposed to be deleted, if answered yes, it will delete the file and register it on the log file.
