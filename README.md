# User Account Creation Script
User Creation Script is a linux Bash scripting project. The script was created to add named parameter functionality to be able to create a user, add them to the admin group, set password and expiry settings for the user as well.

## Description

This Bash script automates **Linux user account creation** with support for:

* Mandatory username creation
* Optional full name, home directory, and login shell
* Admin (sudo) privileges
* Manual or randomly generated passwords
* Password expiry, warning, and inactivity policies
* Strict validation and robust error handling
* Rejection of unexpected positional arguments

The script uses `getopts` to enforce **named parameters only** and prevents invalid or conflicting options.

---

## Usage

```bash
./scriptname.sh -u username [OPTIONS]
```

> ⚠️ The `-u` option is **required**.
> All other options are optional.

---

## Required Option

| Option          | Description            |
| --------------- | ---------------------- |
| `-u <username>` | Username to be created |

---

## Optional Options

| Option           | Description                  | Default            |
| ---------------- | ---------------------------- | ------------------ |
| `-c <fullname>`  | Full name (comment field)    | Not set            |
| `-d <directory>` | Home directory path          | `/home/<username>` |
| `-s <shell>`     | Login shell                  | `/bin/bash`        |
| `-a`             | Add user to `sudo` group     | Disabled           |
| `-p <password>`  | Set a manual password        | Not set            |
| `-P`             | Generate a random password   | Disabled           |
| `-M <days>`      | Max password age             | `30`               |
| `-W <days>`      | Password expiry warning days | `10`               |
| `-I <days>`      | Inactive days after expiry   | `10`               |

---

## Rules & Validations

* `-u` **must** be provided
* Options requiring values **cannot accept another option as input**
* `-p` and `-P` **cannot be used together**
* No positional arguments are allowed
* Password expiry rules:

  * `-M` must be **≥ 20**
  * `-W` and `-I` must be **≥ 0**
* Script exits with meaningful error codes on failure

---

## Examples

### Create a basic user

```bash
./scriptname.sh -u john
```

### Create a user with full name and custom shell

```bash
./scriptname.sh -u john -c "John Doe" -s /bin/zsh
```

### Create a user with admin privileges

```bash
./scriptname.sh -u adminuser -a
```

### Create a user with a manual password

```bash
./scriptname.sh -u john -p mypassword123
```

### Create a user with a random password

```bash
./scriptname.sh -u john -P
```

*Output example:*

```
Username=john    Password=R@nd0mP@ss
```

### Set password expiry policies

```bash
./scriptname.sh -u john -M 45 -W 7 -I 14
```

---

## Exit Codes

| Code  | Meaning                              |
| ----- | ------------------------------------ |
| 11    | No arguments provided                |
| 2–9   | Invalid or missing option values     |
| 10    | Invalid option                       |
| 12    | Unexpected positional arguments      |
| 13    | Username not specified               |
| 14    | `-p` and `-P` used together          |
| 15–17 | Invalid password expiry values       |
| 18    | User creation failed                 |
| 19    | Password expiry configuration failed |
| 20    | Password setting failed              |
| 21    | Failed to add user to sudo group     |

---

## Requirements

* Linux system with:

  * `useradd`
  * `usermod`
  * `chage`
  * `chpasswd`
  * `apg` (required for `-P`)
* Script must be run by a user with **sudo privileges**

---

## Notes

* The script enforces **secure defaults**
* Designed to reject incorrect usage early
* Suitable for system administration labs and production-style scripting
