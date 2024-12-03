#include "tab.h"

TypeTS ts[100];
int cpt = 0;

int rechercher(char entite[]){
    int i=0;
    while(i<cpt){
        if(strcmp(entite,ts[i].nom_entite)==0) return i;
        i++;
    }
    return -1;
}

void inserer(char entite[], char code[]){
    if(rechercher(entite)==-1){
        strcpy(ts[cpt].nom_entite,entite);
        strcpy(ts[cpt].code_entite, code);
        cpt++;
    }
}

void afficher(){
    printf("\n/***************Table des symboles ******************/\n");
    printf("\n_____________________________________________________\n");
    printf("\t| NomEntite | CodeEntite | type entite | constante? |\n");
    printf("\n_____________________________________________________\n");
    int i=0;
    while(i<cpt){
        printf("\t| %10s | %12s | %12s | %12d |\n",ts[i].nom_entite,ts[i].code_entite,ts[i].type_entite,ts[i].cstvar);
        i++;
    }
}

void inserer_type(char entite[], char typee[]){
    int pos = rechercher(entite);
    if(pos != -1){
        strcpy(ts[pos].type_entite, typee);
    }
}

void inserer_cst(char entite[], int v){
    int pos = rechercher(entite);
    if(pos != -1){
        ts[pos].cstvar = v;
    }
}

int Estdeclare(char entite[]){
    int pos = rechercher(entite);
    if(ts[pos].type_entite == NULL) return 0;
    return 1;
}

int Estcst(char entite[]){
    int pos = rechercher(entite);
    if(ts[pos].cstvar == 1) return 1;
    return 0;
}

int son_type(char entite[]){
    int pos = rechercher(entite);
    if(strstr(ts[pos].type_entite, "array")) return 4;
    if(strcmp(ts[pos].type_entite, "") == 0) return 0;
    if(strcmp(ts[pos].type_entite, "int") == 0) return 1;
    if(strcmp(ts[pos].type_entite, "float") == 0) return 2;
    return 3;
}
