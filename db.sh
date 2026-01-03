#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

DIR="./data"
PROJECT_ROOT=$(pwd)

if [[ ! -d "$DIR" ]]; then
    mkdir -p "$DIR" 2>/dev/null
    if [[ $? -ne 0 ]]; then # the exit status is not 0 (not exited successfully)
        echo -e "${RED}Error: Cannot create data directory. Check permissions.${NC}"
        exit 1
    fi
fi

shopt -s nullglob

while true; do
    clear
    echo -e "${BLUE}=========================================="
    echo -e "       BASH DATABASE MANAGEMENT SYSTEM"
    echo -e "==========================================${NC}"
    
PS3=$'\033[1;33m'"Select an option [1-5]: "$'\033[0m'
options=("Create Database" "List Databases" "Connect to Database" "Delete Database" "Exit")

    select choice in "${options[@]}"; do
        case "$choice" in
            "Create Database")
                echo -e "\n${BLUE}--- Create New Database ---${NC}"
                read -p "Enter Database Name: " dbname
                
                #Check if empty
                if [[ -z "$dbname" ]]; then
                    echo -e "${RED}Error: Database name cannot be empty.${NC}"

                # Check Length
                elif [[ ${#dbname} -lt 3 || ${#dbname} -gt 20 ]]; then
                    echo -e "${RED}Error: Name must be between 3 and 20 characters.${NC}"
                #Check Regex (Start with letter, only alphanumeric/underscores)
                elif [[ ! "$dbname" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
                    echo -e "${RED}Error: Use only letters, numbers, or underscores (must start with a letter).${NC}"
                #Check if already exists
                elif [[ -d "$DIR/$dbname" ]]; then
                    echo -e "${RED}Error: Database '${dbname}' already exists!${NC}"
                else
                    mkdir -p "$DIR/$dbname"
                    chmod 700 "$DIR/$dbname"
                    echo -e "${GREEN}Success: Database '${dbname}' created successfully!${NC}"
                fi
                read -p "Press Enter to continue..."
                break
                ;;

            "List Databases")
                echo -e "\n${BLUE}--- Available Databases ---${NC}"
                # Count directories inside data
                count=$(ls -d "$DIR"/*/ 2>/dev/null | wc -l)
                if [[ $count -eq 0 ]]; then
                    echo -e "${YELLOW}The system is currently empty.${NC}" 
                else
                    #basename to show only the folder name, not the path
                    for d in "$DIR"/*/; do
                        echo -e "  ${GREEN}➤${NC} $(basename "$d")" 
                    done
                fi
                echo "---------------------------"
                read -p "Press Enter to return..."
                break
                ;;

            "Connect to Database")
                echo -e "\n${BLUE}--- Connect to Database ---${NC}"
                read -p "Enter Database Name: " enteredname
                #Prevent Path Traversal by stripping any slashes/dots
                clean_name=$(basename "$enteredname" 2>/dev/null)

                #Check if the name is empty or contains illegal characters
                if [[ -z "$clean_name" || ! "$clean_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
                    echo -e "${RED}Error: Invalid Database Name format.${NC}"
    
                    #Check if the directory exists SPECIFICALLY inside your DIR
                    elif [[ -d "$DIR/$clean_name" ]]; then
                        echo -e "${GREEN}Connecting to '$clean_name'...${NC}" 
                        # Move to the safe directory
                        cd "$DIR/$clean_name"

                        #Check if table.sh exists and is executable in the ROOT
                        if [[ -f "$PROJECT_ROOT/table.sh" ]]; then
                            chmod 777 "$PROJECT_ROOT/table.sh"
                            bash "$PROJECT_ROOT/table.sh"
                        else
                            echo -e "${RED}Error: 'table.sh' is missing or not executable in $PROJECT_ROOT.${NC}" 
                        fi
        
                        # Always return to the project root after disconnecting
                        cd "$PROJECT_ROOT"
                        else 
                            echo -e "${RED}Error: Database '$clean_name' not found in system storage.${NC}"
                        fi
                        read -p "Press Enter to continue..."
                    break
                    ;;

            "Delete Database")
                echo -e "\n${RED}--- Delete Database ---${NC}"
                read -p "Enter Name to Delete: " deletedname
                
                #Ensure it's not empty and exists
                if [[ -n "$deletedname" && -d "$DIR/$deletedname" ]]; then
                    echo -e "${YELLOW}WARNING: This will delete everything in '$deletedname'!${NC}"
                    read -p "Type 'yes' to confirm: " confirm
                    if [[ "${confirm,,}" == "yes" ]]; then 
                        rm -rf "$DIR/$deletedname"
                        echo -e "${GREEN}Database deleted successfully.${NC}"
                    else 
                        echo -e "${YELLOW}Deletion cancelled.${NC}"
                    fi
                else 
                    echo -e "${RED}Error: Database '$deletedname' does not exist.${NC}" 
                fi
                read -p "Press Enter to continue..."
                break
                ;;

            "Exit")
                echo -e "${BLUE}Exiting DBMS. Goodbye!${NC}" 
                exit 0
                ;;

            *)
                echo -e "${RED}Invalid selection. Select 1-5.${NC}"
                break
                ;;
        esac
    done
done