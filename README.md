# **Swiss-system tournament generator**
This library gives a developer the tools to easily program a [Swiss-system tournament](https://en.wikipedia.org/wiki/Swiss-system_tournament) in python using a back-end PostgreSQL database.

## **Getting Started**
### Prior to installation
Prior to loading the library, you should have:
- Installed [Vagrant](http://vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/)

### Installation
1. Clone this repo
2. Launch the Vagrant VM (after navigating to the directory in which you saved this repo):
```
$ vagrant up
$ vagrant ssh
```
3. Programs using this library should be saved in the same directory as the cloned repo

## **Common Usage**
Programs that use this library are most often run from the command line but can be run with modifications from other GUI

## **Known Issues**
The code has the following known issues:
1. The number of players registered should be even prior to running `swissPairings()`
    - Unknown errors could occur otherwise
2. Some of the code in `tournament.sql` is, admittedly, not as efficient as it could be
    - Later iterations of this code or pull requests could improve of the `matchlist` and `num_of_matches` views that are currently inefficient

## **License**
This code is covered under an [MIT License](./LICENSE)
