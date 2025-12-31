#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DIR="./data"
mkdir -p "$DIR"
chmod 755 "$DIR" 
shopt -s nullglob
PROJECT_ROOT=$(pwd) 

while true; do
    clear
    echo -e "${BLUE}=========================================="
    echo -e "       BASH DATABASE MANAGEMENT SYSTEM"
    echo -e "==========================================${NC}"
    echo -e "${YELLOW}MAIN MENU${NC}"
    
    PS3=$(echo -e "${YELLOW}Select an option (5 to exit): ${NC}")
    options=("Create Database" "List Databases" "Connect to Database" "Delete Database" "Exit")

    select choice in "${options[@]}"; do
        case "$choice" in
            "Create Database")
                echo -e "\n${BLUE}--- Create New Database ---${NC}"
                while true; do
                    read -p "Enter Database Name (type 'back' to return): " dbname
                    
                    if [[ "$dbname" == "back" ]]; then break; fi
                    if [[ -z "$dbname" ]]; then continue; fi

                    if [ -d "$DIR/$dbname" ]; then
                        echo -e "${RED}Error: Database '${dbname}' already exists!${NC}"
                        continue
                    fi

                    if [[ ${#dbname} -lt 4  || ${#dbname} -gt 64 ]]; then
                        echo -e "${RED}Error: Name must be between 4-64 characters.${NC}"
                        continue
                    fi

                    if [[ ! "$dbname" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
                        echo -e "${RED}Error: Use only letters, numbers, or underscores (must start with a letter).${NC}"
                        continue
                    fi

                    mkdir -p "$DIR/$dbname"
                    chmod 755 "$DIR/$dbname"
                    echo -e "${GREEN}Success: Database '${dbname}' created successfully!${NC}"
                    read -p "Press Enter to continue..."
                    break 
                done
                break
                ;;

            "List Databases")
                echo -e "\n${BLUE}--- Available Databases ---${NC}"
                subdirs=("$DIR"/*/)
                if [ ${#subdirs[@]} -eq 0 ]; then
                    echo -e "${YELLOW}The system is currently empty.${NC}" 
                else
                    for d in "${subdirs[@]}"; do
                        echo -e "  ${GREEN}➤${NC} $(basename "$d")" 
                    done
                fi
                echo "---------------------------"
                read -p "Press Enter to return to menu..."
                break
                ;;

            "Connect to Database")
                # echo -e "\n${BLUE}--- Connect to Database ---${NC}"
                # read -p "Enter Database Name: " enteredname
                # if [ -d "$DIR/$enteredname" ]; then
                #     echo -e "${GREEN}Connecting to '$enteredname'...${NC}" 
                #     cd "$DIR/$enteredname"
                    
                #     # TRANSFER CONTROL TO TABLE SCRIPT 
                #     if [ -f "../../table.sh" ]; then
                #         bash "../../table.sh"
                #     else
                #         echo -e "${RED}Error: table.sh not found!${NC}" 
                #     fi
                    
                #     # Return to root after table script exits 
                #     cd "$PROJECT_ROOT"
                # else 
                #     echo -e "${RED}Error: Database '$enteredname' not found.${NC}"
                # fi
                # read -p "Press Enter to continue..."
                # break
                ;;

            "Delete Database")
                echo -e "\n${RED}--- Delete Database ---${NC}"
                read -p "Enter Database Name to Delete (Case-Sensitive): " deletedname
                if [[ -z "$deletedname" ]]; then
                    echo -e "${RED}Error: No name entered. Deletion aborted.${NC}"

                elif [ -d "$DIR/$deletedname" ] && [ ! -z deletedname ]; then
                    echo -e "${YELLOW}WARNING: This will delete all tables inside '$deletedname'!${NC}"
                    read -p "Are you absolutely sure? (y/n): " answer
                    if [[ "${answer,,}" == "y" || "${answer,,}" == "yes" ]]; then 
                        rm -r "$DIR/$deletedname"
                        echo -e "${GREEN}Database '$deletedname' deleted successfully.${NC}"
                    else 
                        echo -e "${YELLOW}Deletion cancelled.${NC}"
                    fi
                else 
                    echo -e "${RED}Error: Database '$deletedname' not found.${NC}" 
                fi
                read -p "Press Enter to continue..."
                break
                ;;

            "Exit")
                echo -e "${BLUE}Exiting DBMS. Goodbye!${NC}" 
                clear
                exit 0
                ;;

            *)
                echo -e "${RED}Invalid selection. Please try again.${NC}"
                break
                ;;
        esac
    done
done