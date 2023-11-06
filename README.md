<h1> File-Integrity-Monitoring </h1>  

<h2>Description</h2>
Project consist of a powershell script that will alert everytime there are any change in files, adding any files and deleting anyfile base on a base line file that can also be modify through the script. The purpose of this script is to maintain integrity, one of the CIA triad in security, when data is at rest. This is going to be extremely useful when someone inside the organization or someone try to remote access to your system have access to your private data and try to change it up. Also, this script included using hashing algorythm 256 to secure the stored file

<h2>Language and Utilities Used</h2>

- <b>Windows PowerShell</b>

<h2>Program walk-through</h2>

<h3>Step 1: Plannning</h3>
<b>The script have to satisfy all the following requirements:</b> <br/>

&#x2610 Show 2 options: assign new baseline or check folder integrity. The first option is for when you want to change your data intentionally, when the second option is used when you to make sure it has not been changed <br/>

&#x2610 When a new base line is establish, delete all the previous base line to avoid overlaping <br/>

&#x2610 The script have to alert everytime a file is modify, a file is added or a file is deleted <br/>

&#x2610 Check and alert every second  <br/>

&#x2610 Hasing all contents inside all files <br/>

<h3>Step 2: Interface</h3>
<b>The script will include these text as what will be show in each specific scenario</b> <br>

- <b>Start up:</b> What would you like to do? | A) Collect new Baseline? | B) Begin monitoring files with save baseline? | Please enter A or B <br>

- <b>After choosing A:</b> Calculated Hashes, made new baseline.txt <br>

- <b>AFter choosing B:</b> *File*  has been created | *File* has changed!!! | *File* has been deleted! | Show nothing when nothing happen

<h3>Step 3: Script</h3>

Here comes the fun part: <br>



