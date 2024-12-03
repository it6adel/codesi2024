%{
    #include "projet.tab.h"
    #include"tab.h"
    extern YYSTYPE yylval;
    extern int nb_ligne;
%}

idf [a-zA-Z][a-zA-Z0-9_]*
cst [0-9]+
commentaire "##"[^#]*"##"
%%
"Import" { return cm_import; }
"." { return dot; }
"h" { return h_ext; }
"[" { return cro_ouv; }
"]" { return cro_fer; }
"true" { return mc_true; }
"false" { return mc_false;}
"null" { return mc_null; }
"begin" { return cm_begin; }
"end" { return cm_end; }
{commentaire}
"int" { yylval.str=strdup(yytext); return cm_int; }
"float" { yylval.str=strdup(yytext); return cm_float; }
"bool" { yylval.str=strdup(yytext); return cm_bool; }
"const" { yylval.str=strdup(yytext); return cm_const; }
"for" { return cm_for; }
"if" { return cm_if; }
"else" { return cm_else; }


{idf} {if ( yyleng<=15 ){
        if (yytext[yyleng-1]=='_'){
            printf("erreur : l'Identificteur ne peut pas se terminer par '_' a la ligne %d \n",nb_ligne);
            yylval.str=strdup(yytext); inserer(yytext,"idf"); return idf;
        }else{
            if (strstr(yytext,"__")!=NULL){
                printf("la chaine contient '__' a la ligne %d \n",nb_ligne);
                yylval.str=strdup(yytext); inserer(yytext,"idf"); return idf;
            }else{
                yylval.str=strdup(yytext); inserer(yytext,"idf"); return idf;
            }
        }
    }else{
        printf("erreur lexical a la ligne %d : Identificteur %s trop long (plus de 15 caracteres)\n",nb_ligne,yytext);
        yylval.str=strdup(yytext); inserer(yytext,"idf"); return idf;
    }
};

{cst} { yylval.entier=atoi(yytext); return cst; }
"(" { return par_ouv; }
")" {return par_fer; }
"=" { return aff; }
";" { return pvg; }
"," { return vg; }
"+" { return add; }
"*" { return mult; }
"-" { return sous; }
"/" { return divi; }
"{" { return acc_ouv; }
"}" { return acc_fer; }
"<" { return inf; }
">" { return sup; }
"<=" { return infegl; }
">=" { return supegl; }
"<>" { return diff; }
"==" { return egal; }

[ \t]
\n {nb_ligne++;}
. { printf("erreur lexical a la ligne %d sur l'entite %s \n", nb_ligne,yytext); }
%%