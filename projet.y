%{
    char sauvtype[15];
    char here[10];
    char h[10];
    char h1[10];
    char b[10];
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "tab.h"
    extern int yylex();
    extern int yyparse();
    int yyerror(char* msg);
    int nb_ligne=1;
    static int error_count = 0;
%}

%union{
    int entier;
    char* str;
}

%token acc_fer acc_ouv cm_else cm_begin cm_end <str>cm_int <str>cm_bool 
%token <str>cm_float <str>idf <entier>cst par_ouv par_fer aff cm_for cm_if <str>cm_const
%token vg  add mult divi sous pvg inf sup infegl supegl diff egal
%token cm_commentaire mc_null mc_false mc_true
%token cro_ouv cro_fer
%token cm_import dot h_ext

%left add sous
%left mult divi
%left inf sup infegl supegl diff egal

%%
   start : PartieDeclaration cm_begin bloc cm_end {printf("programme syntaxiquement correcte");
   YYACCEPT;};

   PartieDeclaration: declaration_list
                 | /* empty */ ;

declaration_list: dec_var
                | dec_cst
                | import_stmt
                | declaration_list dec_var 
                | declaration_list dec_cst
                | declaration_list import_stmt;

import_stmt: cm_import idf dot h_ext pvg {
    char lib_name[20];
    strcpy(lib_name, $2);
    inserer(lib_name, "library");
    inserer_type(lib_name, "library");
};    dec_var: type ListIdf pvg
           | type idf cro_ouv cst cro_fer pvg { 
               inserer_type($2, strcat(sauvtype,"_array")); 
               inserer_cst($2,0);
           };

    ListIdf: idf vg ListIdf { inserer_type($1,sauvtype); inserer_cst($1,0); }
            | idf { inserer_type($1,sauvtype); inserer_cst($1,0);};

    dec_cst: cm_const type ListIdfCst pvg;

    ListIdfCst: ListIdfCst inst_aff vg
                | inst_aff;

    type: cm_bool { strcpy(sauvtype,$1); }
        | cm_float { strcpy(sauvtype,$1); }
        | cm_int { strcpy(sauvtype,$1); };
        | cm_const { strcpy(sauvtype,$1); };
    
    inst_aff: idf aff cst { inserer_type($1,sauvtype);inserer_cst($1,1);
                        };


    inst_if: cm_if par_ouv CONDITION par_fer acc_ouv bloc acc_fer 
           | cm_if par_ouv CONDITION par_fer acc_ouv bloc acc_fer cm_else acc_ouv bloc acc_fer;
   
    CONDITION: additive_expression inf additive_expression
    | additive_expression sup additive_expression
    | additive_expression infegl additive_expression
    | additive_expression supegl additive_expression
    | additive_expression egal additive_expression
    | additive_expression diff additive_expression;

    additive_expression: multiplicative_expression
    | additive_expression add multiplicative_expression
    | additive_expression sous multiplicative_expression;

    multiplicative_expression:
    expression_primaire
    | multiplicative_expression mult expression_primaire
    | multiplicative_expression divi expression_primaire;

 expression_primaire:
    idf {
        strcpy(h, $1);
        int type_idf = son_type($1);
        if (type_idf == 0) {
            printf("Erreur à la ligne %d : l'identifiant %s n'est pas déclaré.\n", nb_ligne, h);
            error_count++;
        }
    }
    | idf cro_ouv additive_expression cro_fer
    | cst
    | par_ouv additive_expression par_fer;
    inst_affe: idf aff additive_expression {
        strcpy(here, $1);
        int type_idf = son_type(h);
        // Add check for all operands in expression
        if (type_idf != son_type(h)) {
            printf("Type mismatch in expression at line %d\n", nb_ligne);
            error_count++;
        }
    }| idf cro_ouv additive_expression cro_fer aff additive_expression {
    strcpy(here, $1);
    int type_idf = son_type(h);
    if (type_idf != son_type(h)) {
        printf("Type mismatch in array assignment at line %d\n", nb_ligne);
        error_count++;
    }
};;

    inst_for: cm_for par_ouv inst_affe pvg CONDITION pvg cpt par_fer acc_ouv bloc acc_fer
        | error acc_fer { yyerrok; }  // Recovery from malformed for loop

    cpt: idf add add {
    strcpy(here, $1);
    int type_idf = son_type($1);
    
    if (type_idf == 0) {
        printf("Erreur à la ligne %d : l'identifiant %s n'est pas déclaré.\n", nb_ligne, here);
        YYABORT;
    }}
        | idf sous sous {
    strcpy(here, $1);
    int type_idf = son_type($1);
    
    if (type_idf == 0) {
        printf("Erreur à la ligne %d : l'identifiant %s n'est pas déclaré.\n", nb_ligne, here);
        YYABORT;
    }};
      inst_bool: idf aff bol pvg;
      bol: mc_true 
          | mc_false
          | mc_null
      ;

   bloc: instruction_list
      | /* empty */ ;

  instruction_list: instruction
                  | instruction_list instruction;

  instruction: inst_affe pvg
            | inst_for  
            | inst_if
            | inst_bool
            | error pvg { yyerrok; }  // Recovery point

%%

int main(){
    yyparse();
    printf("\nTotal errors found: %d\n", error_count);
    afficher();
    return 0;
}

int yywrap(){
    return 1;
}

int yyerror(char* msg){
    printf("erreur syntaxique a la ligne %d\n",nb_ligne);
    error_count++;
    // Don't exit, continue parsing
    return 0;
}