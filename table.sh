#!/bin/bash
#PS3="Table Menu >> "
while true
do
  echo "1) Create Table"
  echo "2) List Tables"
  echo "3) Drop Table"
  echo "4) Insert Row"
  echo "5) Select Data"
  echo "6) Delete Row"
  echo "7) Update Cell"
  echo "8) Export To CSV (Bonus)"
  echo "9) Exit"
  echo "*********************************************************"


reserved_keywords=("SELECT" "FROM" "WHERE" "INSERT" "UPDATE" "DELETE" "TABLE" "CREATE" "DROP")

valid_datatypes=("Int" "String" "Float" "Date")

validate_not_empty() {
  local name="$1"
  [[ -z "$name" ]] && echo "Error: Name cannot be empty" && return 1
  return 0
}

validate_format() {
  local name="$1"
  [[ ! $name =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]] && echo "Error: Invalid format. Must start with a letter and contain only letters, numbers, or underscores." && return 1
  return 0
}

validate_reserved() {
  local name_upper="${1^^}" # convert to uppercase
  for keyword in "${reserved_keywords[@]}"; do
    [[ "$name_upper" == "$keyword" ]] && echo "Error: '$1' is a reserved keyword." && return 1
  done
  return 0
}

validate_table_exists() {
  local name="$1"
  [ -f "$name.data" ] && echo "Error: Table '$name' already exists." && return 1
  return 0
}

validate_positive_integer() {
  local num="$1"
  [[ ! "$num" =~ ^[1-9][0-9]*$ ]] && echo "Error: Must enter a positive integer." && return 1
  return 0
}

validate_datatype() {
  local dtype="${1^}"  # capitalize first letter
  for dt in "${valid_datatypes[@]}"; do
    [[ "$dtype" == "$dt" ]] && return 0
  done
  echo "Error: Datatype must be one of: ${valid_datatypes[*]}"
  return 1
}

create_table() {
  read -p "Enter table name: " tname

  validate_not_empty "$tname" || return
  validate_format "$tname" || return
  validate_reserved "$tname" || return
  validate_table_exists "$tname" || return

  read -p "Number of columns: " cols
  validate_positive_integer "$cols" || return

  > "$tname.meta"
  > "$tname.data"

  declare -A col_names

  for ((i=1;i<=cols;i++)); do
      while true; do
      read -p "Column $i name: " cname
      validate_not_empty "$cname" || continue
      validate_format "$cname" || continue
      validate_reserved "$cname" || continue
      [[ -n "${col_names[$cname]}" ]] && echo "Error: Column name must be unique." && continue
      col_names[$cname]=1
      break
    done

    while true; do
      read -p "Datatype (Int/String/Float/Date): " dtype
      validate_datatype "$dtype" || continue
      break
    done

    if [ $i -eq 1 ]; then
      echo "$cname:$dtype:PK" >> "$tname.meta"
    else
      echo "$cname:$dtype" >> "$tname.meta"
    fi
  done

  echo "Table '$tname' created successfully!"
    echo "*********************************************************"
}


drop_table() {
  read -p "Enter table name to drop: " tname

  if [ ! -f "$tname.data" ] || [ ! -f "$tname.meta" ]; then
    echo "Error: Table '$tname' does not exist."
    return
  fi


  read -p "Are you sure you want to delete table '$tname'? [y/N]: " confirm
  confirm=${confirm,,}
  if [[ "$confirm" != "y" ]]; then
    echo "Aborted."
    return
  fi


  rm "$tname.data" "$tname.meta"
  echo "Table '$tname' deleted successfully!"
    echo "*********************************************************"
}

export_to_csv() {
  read -p "Enter table name to export: " tname

  # Check if table exists
  if [ ! -f "$tname.data" ] || [ ! -f "$tname.meta" ]; then
    echo "Error: Table '$tname' does not exist."
    return
  fi

  csv_file="${tname}.csv"

  # Write headers (column names from meta)
  awk -F: '{print $1}' "$tname.meta" | paste -sd "," - > "$csv_file"

  # Write data (convert : to ,)
  tr ':' ',' < "$tname.data" >> "$csv_file"

  echo "Table '$tname' exported to '$csv_file' successfully!"
  echo "*********************************************************"
}


insert_row() {
  read -p "Table name: " tname
  [ ! -f "$tname.meta" ] && echo "Error: Table '$tname' does not exist." && return

  row=""
  while IFS=: read cname dtype pk
  do
    while true; do

    read -p "Enter $cname ($dtype): " val < /dev/tty
#      read -p "Enter $cname ($dtype): " val

      val="${val// /}"  # remove spaces around input

      # Check empty input
      [ -z "$val" ] && echo "Error: Value cannot be empty." && continue

      # Datatype validation
      case "${dtype^}" in
        Int)
          [[ ! "$val" =~ ^[0-9]+$ ]] && echo "Error: Must be a positive integer." && continue
          ;;
        Float)
          [[ ! "$val" =~ ^[0-9]+([.][0-9]+)?$ ]] && echo "Error: Must be a float." && continue
          ;;
        Date)
          [[ ! "$val" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && echo "Error: Must be YYYY-MM-DD." && continue
          if ! date -d "$val" >/dev/null 2>&1; then
    echo "Error: Invalid date."
    continue
  fi
  ;;
       String)
    max_length=30
    if [ ${#val} -gt $max_length ]; then
        echo "Error: String too long. Maximum $max_length characters allowed."
        continue
    fi
  
if [[ "$val" == *:* ]]; then
        echo "Error: String cannot contain ':' character."
        continue
    fi
    ;;
        *)
          echo "Error: Unknown datatype '$dtype'." && return
          ;;
      esac

      # Primary key check
      if [ "$pk" == "PK" ]; then
        if cut -d: -f1 "$tname.data" | grep -wq "$val"; then
          echo "Error: Primary key '$val' already exists."
          continue
        fi
      fi

      break
    done

    row+="$val:"
  done < "$tname.meta"

  echo "${row::-1}" >> "$tname.data"
  echo "Row inserted successfully!"
    echo "*********************************************************"
}

list_tables() {
  for f in *.data; do
    if [[ $f == "*.data" ]]; then
      echo "No tables found."
      return
    fi
    echo "${f%.data}"
  done
}

select_data() {
  read -p "Enter table name: " tname

  # Check if table exists
  if [ ! -f "$tname.data" ] || [ ! -f "$tname.meta" ]; then
    echo "Error: Table '$tname' does not exist."
    return
  fi

{
  awk -F: '{print $1}' "$tname.meta" | paste -sd ":" -
  cat "$tname.data"
} | column -t -s ":"
  echo "*********s************************************************"
}

delete_row() {
  read -p "Enter table name: " tname

  # Check if table exists
  if [ ! -f "$tname.data" ] || [ ! -f "$tname.meta" ]; then
    echo "Error: Table '$tname' does not exist."
    return
  fi

  read -p "Enter PK value to delete: " id

  # Check if PK exists
  if ! grep -q "^$id:" "$tname.data"; then
    echo "Error: PK '$id' not found in table."
    return
  fi

  # Delete the row safely
  sed -i "/^$id:/d" "$tname.data"

  echo "Row with PK '$id' deleted successfully."
    echo "*********************************************************"
}

update_cell() {
  read -p "Enter table name: " tname

  # Check if table exists
  if [ ! -f "$tname.data" ] || [ ! -f "$tname.meta" ]; then
    echo "Error: Table '$tname' does not exist."
    return
  fi

  read -p "Enter PK value: " id
  id="${id// /}"  # remove spaces

  # Check if PK exists
  if [ -z "$id" ]; then
    echo "Error: PK cannot be empty."
    return
  fi

  if ! grep -q "^$id:" "$tname.data"; then
    echo "Error: PK value '$id' not found."
    return
  fi

  # Number of columns in the table
  total_cols=$(wc -l < "$tname.meta")

  read -p "Enter Column number: " col
  col="${col// /}"  # remove spaces

  # Validate column number
  if ! [[ "$col" =~ ^[0-9]+$ ]] || (( col < 1 || col > total_cols )); then
    echo "Error: Invalid column number. Must be between 1 and $total_cols."
    return
  fi

  read -p "Enter New value: " val
  val="${val// /}"  # remove spaces

  # Check empty value
  if [ -z "$val" ]; then
    echo "Error: Value cannot be empty or spaces only."
    return
  fi

  # Get datatype from meta
  dtype=$(sed -n "${col}p" "$tname.meta" | cut -d: -f2)

  # Validate based on datatype
  case "${dtype^}" in
    Int)
      if ! [[ $val =~ ^[0-9]+$ ]]; then
        echo "Error: Value must be an integer."
        return
      fi
      ;;
    Float)
      if ! [[ $val =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: Value must be a float."
        return
      fi
      ;;
    String)
    max_length=30
    if [ ${#val} -gt $max_length ]; then
        echo "Error: String too long. Maximum $max_length characters allowed." 
        continue
    fi
    if [[ "$val" == *:* ]]; then
        echo "Error: String cannot contain ':' character."
        return
    fi
      ;;
    Date)
      if ! [[ $val =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Error: Date must be in DD-MM-YYYY format."
        return
      fi
      if ! date -d "$val" >/dev/null 2>&1; then
        echo "Error: Invalid date."
        return
      fi
      ;;
    *)
      echo "Warning: Unknown datatype '$dtype'. No validation applied."
      ;;
  esac

  # Update the value in data file
  awk -F: -v id="$id" -v col="$col" -v val="$val" 'BEGIN{OFS=":"} $1==id {$col=val} { print }' "$tname.data" > tmpfile && mv tmpfile "$tname.data"
  echo "Value updated successfully."
}


  read -p "Choose option: " choice

  case $choice in
    1) create_table ;;
    2) list_tables ;;
    3) drop_table ;;
    4) insert_row ;;
    5) select_data ;;
    6) delete_row ;;
    7) update_cell ;;
    8) export_to_csv ;;
    9) exit ;;
    *) echo "Invalid choice" 
    echo "****************************"
    ;;
  esac
done

