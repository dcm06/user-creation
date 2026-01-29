
#!/bin/bash - Instructions
#Chinemerem David Madubuko 1222911


#USAGE GUIDE 
usage(){      
	echo "USAGE:    $0"
}

#ERROR HANDLING IF NO PARAMETERS OR ARGUMENTS PROVIDED
if [ $# -eq 0 ]; then
	echo "Error: No Arguments Provided."
	usage
	exit 11
fi


#PARAMETER VARIABLES
US="" #-u
FULLNAME="" #-c
HOME="/home" #-d
SHELL="/bin/bash" #-s
ADMIN=false #-a
PASS="" #-p
RAND=0  #-P
MAX="30" #-M
WARN="10" #-W
INACTIVE="10" #-I

#Additional Variables
homedir=""
otherflag=false
fullnameset=false
maxset=false
warnset=false
inactiveset=false

#While Loop for Getops
while getopts :u:c:d:s:ap:PM:W:I: opt; do
	
	case $opt in 
		u)
		#Validation and Error handling for -u
		   if [[ -z "$OPTARG" || "$OPTARG" ==  -* ]]; then
			echo "Error: Invalid, -u Requires a value, not an option" 
			usage
			exit 2
		   fi
		   US="$OPTARG"
		   ;;
                c)
                #Validation and Error handling for -c
		   if [[ -z "$OPTARG" || "$OPTARG" ==  -* ]]; then
			echo "Error: Invalid, -c Requires a value, not an option" 
			usage
			exit 3
		   fi
		   otherflag=true
		   fullnameset=true
		   FULLNAME="$OPTARG"

		  
		    ;;
		d)
		#Validation and Error handling for -d
		   if [[ -z "$OPTARG" || "$OPTARG" ==  -* ]]; then
			echo "Error: Invalid, -d Requires a value, not an option" 
			usage
			exit 4
		   fi
		   otherflag=true
                   homedir="$OPTARG"

		  
                   ;; 
                s) 
                #Validation and Error handling for -s
		   if [[ -z "$OPTARG" || "$OPTARG" ==  -* ]]; then
			echo "Error: Invalid, -s Requires a value, not an option" 
			usage
			exit 5
		   fi
                   SHELL="$OPTARG"
                   otherflag=true
                   
                   ;;
                a) 
                   ADMIN=true
                   
                   
                   ;; 
                p) 
                #Validation and Error handling for -p
		   if [[ -z "$OPTARG" || "$OPTARG" ==  -* ]]; then
			echo "Error:Invalid, -p Requires a value, not an option" 
			usage
			exit 6
		   fi
                   PASS="$OPTARG"
                   
		   
                   ;; 
                P) 
		   RAND=1
		   
                    
                   ;; 
                M) 
                #Validation and Error handling for -M
		   if [[ -z "$OPTARG" || "$OPTARG" ==  -* ]]; then
			echo "Error: Invalid, -M Requires a value, not an option" 
			usage
			exit 7
		   fi
                   MAX="$OPTARG"
                   maxset=true

                   
                  
                   ;; 
                W) 
                #Validation and Error handling for -W
		   if [[ -z "$OPTARG" || "$OPTARG" ==  -* ]]; then
			echo "Error:Invalid, -W Requires a value, not an option" 
			usage
			exit 8
		   fi
                   WARN="$OPTARG"
                   warnset=true

                   
                   ;; 
                I) 
                #Validation and Error handling for -I
		   if [[ -z "$OPTARG" || "$OPTARG" ==  -* ]]; then
			echo "Error: Invalid, -I Requires a value, not an option" 
			usage
			exit 9
		   fi
                   INACTIVE="$OPTARG"
                   inactiveset=true
                   
                  
                   ;;  
		:) #ERROR HANDLING WHEN A PARAMETER THAT REQUIRES AN ARGUMENT IS EMPTY
		   echo "Option -$OPTARG requires an argument"
		   exit 1
		   ;;
		\?) #ERROR HANDLING WHEN AN INVALID OPTION IS PASSED
		   echo "Error: Invalid option -$OPTARG"
		   exit 10
		   ;;
	esac
done
shift $((OPTIND -1))

#ERROR HANDLING WHEN AN UNEXPECTED POSITIONAL ARGUMENT IS USED
if [ "$#" -gt 0 ]; then

  echo "Error: Unexpected arguments: $*"
  exit 12
fi

#Extra Validation and Error HANDLING IF USERNAME IS NOT SPECIFIED
if [ -z "$US" ]; then
	echo "Error: Username is Required when using other options"
	usage
	exit 13
fi

#PASSWORD SETTINGS VALIDATION AND ERROR HANDLING - -P and -p cannot be used together
if [ -n "$PASS" ] && [ $RAND -ne 0 ]; then 
	echo "Error: -P and -p cannot be used together, use either one of them only"
	usage
	exit 14

fi



#PASSWORD EXPIRY VALIDATION AND ERROR HANDLING
if [ $MAX -lt 20 ]; then
	echo "Error: Invalid -M value"
	usage
	exit 15

elif [ $WARN -lt 0 ]; then
	echo "Error: Invalid -W value"
	usage
	exit 16

elif [ $INACTIVE -lt 0 ]; then
	echo "Error: Invalid -I value"
	usage
	exit 17
fi
	
	
##DEFAULT HOME DIRECTORY IF NO HOME DIRECTORY IS SPECIFIED
if [ -z "$homedir" ]; then
	homedir="$HOME/$US"
fi



#User Creation FUNCTION
createuser(){
	#IF FULLNAME IS SPECIFIED
	if [ "$fullnameset"=true ]; then
		error=$(sudo useradd -c "$FULLNAME" -d "$homedir" -s "$SHELL" "$US" 2>&1)
		status=$?
	else

		error=$(sudo useradd -d "$homedir" -s "$SHELL" "$US" 2>&1)
		status=$?
				
	fi
	
	#ERROR OUTPUT - 1 higher than the one in step 9
	if [ $status -ne 0 ]; then
		echo "Command failed"
		echo "Error: $error"
		exit 18	
	fi
}

#PASSWORD EXPIRY FUNCTION
passexpiry() {
	# Maximum number of days between required password changes for the new account - Validated input must be a number greater than or equal to 20
	if [ $MAX -gt 20 ] || [ $MAX -eq 20 ]; then
		#chage command used to set password expiry settings
		error=$(sudo chage -M "$MAX" "$US")
		status=$?
	fi
	
	
	# Number of days of Warning before password expires - Validated input must be a number greater than 0
	if [ $WARN -gt 0 ]; then
		#chage command used to set password expiry settings
		error=$(sudo chage -W "$WARN" "$US")
		status=$?
	fi

	# Number of days before account becomes inactive after password expires - Validated input must be a number greater than 0
	if [ $INACTIVE -gt 0 ]; then
		#chage command used to set password expiry settings
		error=$(sudo chage -I "$INACTIVE" "$US")
		status=$?
	fi


	#ERROR OUTPUT - 1 higher than the one in step 12
	if [ $status -ne 0 ]; then
		echo "Error: $error"
		exit 19
	fi
	
	
}



#USER CREATION
if [ -n "$US" ] && [ "$otherflag"=false ]; then
	createuser
elif [ -n "$US" ]; then
	createuser
fi

#RUN PASSWORD EXPIRY COMMANDS
if [ $MAX -gt 20 ] || [ $MAX -eq 20 ] || [ $WARN -gt 0 ] || [ $INACTIVE -gt 0 ]; then
	passexpiry
	
fi

#ADD PASSWORD SETTINGS
if [ -n "$PASS" ] || [ $RAND -ne 0 ]; then 
	#chpasswd used to set password
	if [ -n "$PASS" ]; then
		error=$(echo "$US:$PASS" | sudo chpasswd )
		status=$?
	fi
	
	#RANDOM PASSWORD SET - Print the Username and Password on the Screen separated by tab
	if [ $RAND -ne 0 ]; then
		#apg used to generate the random password, password generated saved in the variable for -p parameter
		PASS=$(apg -n 1 -m 8 -x 16)
		#chpasswd used to set password
		error=$(echo "$US:$PASS" | sudo chpasswd )
		status=$?
		echo -e "Username=$US\tPassword=$PASS"
		
	fi
	
	#ERROR OUTPUT - 1 higher than the one in step 13c
	if [ $status -ne 0 ]; then
		echo "Error: $error"
		exit 20
	fi
fi


#ADD User in Admin Group
if [ "$ADMIN"=true ]; then
	error=$(sudo usermod -aG sudo "$US")
	status=$?
	
	if [ $status -ne 0 ]; then
		echo "Error: Unable to add to Execute the option -a : $error"
		exit 21
	fi
fi

exit 0

