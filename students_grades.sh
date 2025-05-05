#!/bin/bash

# Έλεγχος αν δόθηκε όρισμα στη γραμμή εντολών
if [ $# -eq 0 ]; then
    echo "Παρακαλώ δώστε έναν κατάλογο ως όρισμα."
    exit 1
fi

# Κατάλογος με τους φοιτητές
students_directory="$1"

# Έλεγχος αν υπάρχει το αρχείο grades.txt και διαγραφή αν υπάρχει
if [ -e "grades.txt" ]; then
    rm "grades.txt"
fi

# Ερώτηση για οργάνωση αρχείων σε κατάλογο
read -p "Θέλετε να οργανώσετε τα αρχεία των φοιτητών σε έναν κατάλογο; (Y/N): " organize_files

# Δημιουργία του καταλόγου organized αν το χρήστη επιθυμεί
if [ "${organize_files^^}" == "Y" ]; then
    if [ -e "organized" ]; then
        rm -r "organized"
    fi
    mkdir "organized"
fi

# Επανάληψη για κάθε φοιτητή στον κατάλογο
for student_directory in "${students_directory}"/*; do
    if [ -d "${student_directory}" ]; then
        # Αρχεία projects
        project1="${student_directory}/project1.c"
        project2="${student_directory}/project2.c"
        
        # Αρχείο report.txt
        report_file="${student_directory}/report.txt"

        # Διαβάζουμε τα περιεχόμενα του report.txt
        student_info=$(cat "${report_file}")

        # Χωρίζουμε τα στοιχεία του φοιτητή
        student_name=$(echo "${student_info}" | awk '{print $1}')
        student_id=$(echo "${student_info}" | awk '{print $2}')


        # Εκτέλεση των προγραμμάτων C
        grade1=$(gcc -o project1_temp "${project1}" && ./project1_temp)
        grade2=$(gcc -o project2_temp "${project2}" && ./project2_temp)

        rm project1_temp
        rm project2_temp
        
        # Έλεγχος για τους βαθμούς και υπολογισμός συνολικού βαθμού
        if [ "${grade1}" -eq 20 ]; then
            project1_grade=30
        else
            project1_grade=0
        fi

        if [ "${grade2}" -eq 10 ]; then
            project2_grade=70
        else
            project2_grade=0
        fi

        total_grade=$((project1_grade + project2_grade))

        # Εκτύπωση στο αρχείο grades.txt
        echo "${student_name} ${student_id} ${project1_grade} ${project2_grade} ${total_grade}" >> "grades.txt"

        # Αντιγραφή των αρχείων στον κατάλογο organized, αν επιθυμεί ο χρήστης
        if [ "${organize_files^^}" == "Y" ]; then
            cp "${project1}" "organized/${student_name}_${student_id}_project1.c"
            cp "${project2}" "organized/${student_name}_${student_id}_project2.c"
        fi
    fi
done

# Εκτύπωση μηνύματος ολοκλήρωσης
echo "Η εκτέλεση ολοκληρώθηκε επιτυχώς."
