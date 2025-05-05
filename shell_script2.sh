#!/bin/bash

# Συνάρτηση για τη δημιουργία αρχείου με στοιχεία φοιτητών
create_student_file() {
    echo "Δημιουργία αρχείου με στοιχεία φοιτητών"
    # Εδώ μπορείτε να υλοποιήσετε τον κώδικα για τη δημιουργία του αρχείου

    touch studentStats.txt
    read -p "Επώνυμο: " LAST_NAME
    read -p "Όνομα: " FIRST_NAME
    read -p "Αριθμός Ταυτότητας: " ID_NUMBER
    read -p "Βαθμός: " GRADE
    read -p "Τμήμα: " DEPARTMENT

    # Βρίσκει τον αριθμό της γραμμής
    LINE_NUMBER=$(wc -l < studentStats.txt)
    ((LINE_NUMBER++))
    # Εκτυπώνει τα στοιχεία στο αρχείο test.txt
    echo  "$LINE_NUMBER $LAST_NAME $FIRST_NAME $ID_NUMBER $GRADE $DEPARTMENT" >> studentStats.txt
    #(κωδικός, επώνυμο, όνομα, αριθμός ταυτότητας, βαθμός, τμήμα)

}

# Συνάρτηση για την προσθήκη νέου φοιτητή
add_new_student() {
    echo "Προσθήκη νέου φοιτητή"
    # Διαβάζει τα στοιχεία από τον χρήστη
    read -p "Επώνυμο: " LAST_NAME
    read -p "Όνομα: " FIRST_NAME
    read -p "Αριθμός Ταυτότητας: " ID_NUMBER
    read -p "Βαθμός: " GRADE
    read -p "Τμήμα: " DEPARTMENT

    echo "Αρχείο προς εγγραφή: "
    read file1
    if [ -f "$file1" ]; then
      echo "Το αρχείο υπάρχει. "
      # Εκτυπώνει τα στοιχεία στο αρχείο
      LINE_NUMBER=$(wc -l < studentStats.txt)
      ((LINE_NUMBER++))
      echo "$LINE_NUMBER $LAST_NAME $FIRST_NAME $ID_NUMBER $GRADE $DEPARTMENT" >> $file1
    else
      echo "Το αρχείο δεν υπάρχει. Δημιουργία αρχείου..."
      touch $file1
      LINE_NUMBER=$(wc -l < $file1)
      ((LINE_NUMBER++))
      echo "$LINE_NUMBER $LAST_NAME $FIRST_NAME $ID_NUMBER $GRADE $DEPARTMENT" >> $file1
    fi
}

# Συνάρτηση για την αναζήτηση φοιτητή με βάση τον αριθμό μητρώου
search_student_by_id() {
    echo "Αναζήτηση φοιτητή με βάση τον αριθμό μητρώου"
    # Ζητάμε από τον χρήστη να εισάγει τον αριθμό μητρώου
    read -p "Εισάγετε τον αριθμό μητρώου: " SEARCH_ID
    correct=true
    while [ $correct = true ]; do

      # Έλεγχος αν ο αριθμός μητρώου έχει μήκος 6 χαρακτήρες
      if [ ${#SEARCH_ID} -ne 6 ]; then
        echo "O αριθμός μητρώου πρέπει να έχει μήκος 6 χαρακτήρες."
        read -p "Εισάγετε τον αριθμό μητρώου: " SEARCH_ID
        correct=true
      else
        correct=false
      fi

      # Έλεγχος αν ο αριθμός μητρώου περιλαμβάνει μόνο ψηφία 0-9
      if ! [[ $SEARCH_ID =~ ^[0-9]+$ ]]; then
        echo "Ο αριθμός μητρώου πρέπει να περιλαμβάνει μόνο ψηφία 0-9."
        read -p "Εισάγετε τον αριθμό μητρώου: " SEARCH_ID
        correct=true
      else
        correct=false
      fi
      # Αν το πρόγραμμα έχει φτάσει ως εδω, σημαίνει ότι ο αριθμός μητρώου είναι έγκυρος και είναι δυνατή η αναζήτηση
    done
# Χρησιμοποιούμε την grep για να αναζητήσουμε τον αριθμό ταυτότητας στο αρχείο.
result=$(grep "$SEARCH_ID" studentStats.txt)

# Έλεγχος αν υπάρχουν αποτελέσματα
if [ -n "$result" ]; then
    echo "Βρέθηκε ο φοιτητής:"
    echo "$result"
else
    echo "Δεν βρέθηκε φοιτητής με αυτόν τον αριθμό ταυτότητας."
fi
}

# Συνάρτηση για την προβολή στατιστικών στοιχείων
display_statistics() {
  # Αρχικοποίηση των μεταβλητών μετρητών
  for variable in ${!count_*}; do
    unset $variable
  done

  while IFS= read -r line; do
    # Χρησιμοποιούμε την εντολή awk για να πάρουμε την έκτη λέξη από κάθε γραμμή
    sixth_word=$(echo "$line" | awk '{print $6}')
    
    # Αν η έκτη λέξη υπάρχει, αυξάνουμε τον μετρητή για αυτήν
    if [ -n "$sixth_word" ]; then
      # Ελέγχουμε αν η λέξη υπάρχει ήδη
      eval "count_$sixth_word=\$((count_$sixth_word + 1))"
    fi
  done < studentStats.txt

  # Εκτύπωση των αποτελεσμάτων
  echo "Τμήματα και φορές εμφανίσεων:"
  for variable in ${!count_*}; do
    word=${variable#count_}
    count=${!variable}
    echo "$word: $count "
  done
}

# Κύριο βρόχος επιλογών
while true; do
    # Εμφάνιση του μενού επιλογών
    echo "Μενού Επιλογών:"
    echo "1. Δημιουργία αρχείου με στοιχεία φοιτητών"
    echo "2. Προσθήκη νέου φοιτητή"
    echo "3. Αναζήτηση φοιτητή με βάση τον αριθμό μητρώου"
    echo "4. Προβολή στατιστικών στοιχείων"
    echo "5. Έξοδος"

    # Ανάγνωση της επιλογής του χρήστη
    read -p "Επιλέξτε μια ενέργεια (1-5): " choice

    # Εκτέλεση της επιλεγμένης ενέργειας
    case $choice in
        1) create_student_file ;;
        2) add_new_student ;;
        3) search_student_by_id ;;
        4) display_statistics ;;
        5)
            echo "Έξοδος από το πρόγραμμα."
            exit 0
            ;;
        *)
            echo "Μη έγκυρη επιλογή. Παρακαλώ επιλέξτε ξανά."
            ;;
    esac
    echo
done

