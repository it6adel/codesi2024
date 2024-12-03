#ifndef TABLESYMBOLES_H
#define TABLESYMBOLES_H

#include <string.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct tablesymboles {
    char nom_entite[10];
    char code_entite[10];
    char type_entite[15];
    int cstvar;
} TypeTS;

extern TypeTS ts[100];
extern int cpt;

int rechercher(char entite[]);
void inserer(char entite[], char code[]);
void afficher();
void inserer_type(char entite[], char typee[]);
void inserer_cst(char entite[], int v);
int Estdeclare(char entite[]);
int Estcst(char entite[]);
int son_type(char entite[]);

#endif
