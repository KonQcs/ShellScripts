#! /bin/bash
# Αποθήκευση του ονόματος του καταλόγου από το όρισμα
echo "Type folder name: "
read dir1
# Έλεγχος για την ύπαρξη του καταλόγου
if [ -d "$dir1" ]; then
  echo "Folder already exists. "
else 
  mkdir "$dir1"
  echo "Folder created. "
  

  if [ -d dir2 ]; then
    echo "Folder already exists. "
  
  else
    if [ -d dir3 ]; then
      echo "Folder already exists. "
    
    else
      # Δημιουργία των δύο νέων καταλόγων αν δεν υπάρχουν
      mkdir dir2
      mkdir dir3
      echo "Folders created. "
      # Εύρεση και μετακίνηση αρχείων στους νέους καταλόγους 
      find . -maxdepth 1 -type f -name "[A-La-l]*" -exec mv {} dir2 \;
      find . -maxdepth 1 -type f -name "[M-Zm-z]*" -exec mv {} dir3 \;

      echo "Files moved. "
      # Καταμέτρηση και εκτύπωση πλήθους αρχείων σε νέο αρχείο
      total_files_dir2=$(find dir2 -type f | wc -l)
      total_files_dir3=$(find dir3 -type f | wc -l)
      echo "Total files in dir2: $total_files_dir2" > total_files.txt
      echo "Total files in dir3: $total_files_dir3" >> total_files.txt
    fi
  fi
fi