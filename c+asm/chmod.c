#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// chmod.c
extern void asm_chmod(char *path, int mode);

int main() {
    char path[256];  
    int mode;

 
    printf("Podaj nazwę ścieżki: ");
    fgets(path, sizeof(path), stdin);
    path[strcspn(path, "\n")] = '\0';  


    printf("Podaj tryb dostępu (w oktalnym formacie): ");
    scanf("%o", &mode);

   
    if (strlen(path) == 0) {
        fprintf(stderr, "Błąd: Podano pustą nazwę ścieżki.\n");
        return 1;
    }

    if (mode > 0777) {
        fprintf(stderr, "Błąd: Podano niepoprawny tryb dostępu.\n");
        return 1;
    }

 
    asm_chmod(path, mode);

    return 0;
}
//nasm -f elf asm_chmod.asm -o asm_chmod.o
//gcc -m32 -o program program.c asm_chmod.o
//./program
