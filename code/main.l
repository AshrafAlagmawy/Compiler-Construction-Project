%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include <math.h>
	#include "main.tab.h"
	void yyerror(char *);
	#define MAX_SIZE 1000
	int num_of_v=0;

	struct KeyValue {
		char key[20];
		int value;
	};

	struct KeyValue myMap[MAX_SIZE]; // Assuming a fixed size for simplicity

	void addToMap(const char *key, int value) {
		for (int i = 0; i < MAX_SIZE; ++i) {
			if (strcmp(myMap[i].key, key) == 0) {
				// Key already exists, update the value
				myMap[i].value = value;
				return;
			}
		}

		// Key not found, add a new entry
		for (int i = 0; i < MAX_SIZE; ++i) {
			if (myMap[i].key[0] == '\0') {
				strcpy(myMap[i].key, key);
				myMap[i].value = value;
				return;
			}
		}

		// Map is full
		printf("Error: Map is full, cannot add more entries.\n");
	}

	int getValueFromMap(const char *key) {
		for (int i = 0; i < MAX_SIZE; ++i) {
			if (strcmp(myMap[i].key, key) == 0) {
				return myMap[i].value;
			}
		}

		// Key not found
		return -1; // You can choose a different sentinel value or handle it differently
	}
%}

VARIABLE    			[a-zA-Z][a-zA-Z0-9]*
DIGIT 					[0-9]
COMMENT					[#].*
WHITESPACE				[ \t\n\r]
SYMBOLS					[-+/*<>=,():;%^]
IS_EQUAL				[=][=]
IS_NOT_EQUAL			[!][=]
GREATER_THAN_OR_EQUAL	[>][=]
LESS_THAN_OR_EQUAL		[<][=]
AND						[&][&]
OR						[|][|]
NOT						[!]

%%
"CASE"					{ return CASE; }
"SWITCH" 				{ return SWITCH; }
"DEFAULT" 				{ return DEFAULT; }
"PRINT" 				{ return PRINT; }
"IF"					{ return IF; }
"ELSE" 		   			{ return ELSE; }
"{" 		   			{ return BRACKETSTART; }
"}"  		   			{ return BRACKETEND; }
"FOR" 		   			{ return FOR; }
"WHILE"		   			{ return WHILE; }
"INT"  					{ return INT; }
"CHAR" 		     		{ return CHAR; }
"FLOAT"			 		{ return FLOAT; }
"DOUBLE"				{ return DOUBLE; }
"BOOLEAN"           	{ return BOOLEAN; }
"Main"	   				{ return MAIN; }
"PRINTL"				{ return PRINTL; }

{DIGIT}+   		    	{   /* integers */
							yylval = atoi(yytext);
							return NUM;
						}
{COMMENT}           	{ fprintf(yyout, "\nSingle line comment found -> "); ECHO; fprintf(yyout, "\n");}

{SYMBOLS}    			{ yylval = yytext[0]; return *yytext; }

{VARIABLE}				{ 	ECHO;/* variables */
							if(getValueFromMap(yytext) == -1) {
									addToMap(yytext, num_of_v);
									yylval = num_of_v;
									num_of_v++;
							}
							else
								yylval = getValueFromMap(yytext);
							return VAR;
						}

{WHITESPACE}*	    	{ /* Ignore whitespace */ }
{IS_EQUAL}				{ return IS_EQUAL; }
{IS_NOT_EQUAL}			{ return IS_NOT_EQUAL; }
{GREATER_THAN_OR_EQUAL}	{ return GREATER_THAN_OR_EQUAL; }
{LESS_THAN_OR_EQUAL}	{ return LESS_THAN_OR_EQUAL; }
{AND}					{ return AND; }
{OR}					{ return OR; }
{NOT}					{ return NOT; }
.						{ yyerror("Invalid syntax"); }
%%
