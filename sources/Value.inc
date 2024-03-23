; Value.inc : 変数
;


; マクロの定義
;

; 値
VALUE_A_L                       =   0x00    ; A  = AMOUNT SPENT ON ANIMALS
VALUE_A_H                       =   0x01
VALUE_B_L                       =   0x02    ; B  = AMOUNT SPENT ON AMMUNITION
VALUE_B_H                       =   0x03
VALUE_B1_L                      =   0x04    ; B1 = ACTUAL RESPONSE TIME FOR INPUTTING "BANG"
VALUE_B1_H                      =   0x05
VALUE_B3                        =   0x06    ; B3 = CLOCK TIME START OF INPUTTING "BANG"
VALUE_C_L                       =   0x07    ; C  = AMOUNT SPENT ON CLOTHING
VALUE_C_H                       =   0x08
VALUE_C1                        =   0x09    ; C1 = FLAG FOR INSUFFICIENT CLOTHING IN COLD WEATHER
VALUE_C_STRING                  =   0x0a    ; C$ = YES/NO RESPONSE TO QUESTIONS
VALUE_D1                        =   0x0b    ; D1 = COUNTER IN GENERATING EVENTS
VALUE_D3                        =   0x0c    ; D3 = TURN NUMBER FOR SETTING DATE
VALUE_D4                        =   0x0d    ; D4 = CURRENT DATE
VALUE_D9                        =   0x0e    ; D9 = CHOICE OF SHOOTING EXPERTISE LEVEL
VALUE_E                         =   0x0f    ; E  = CHOICE OF EATING
VALUE_F_L                       =   0x10    ; F  = AMOUNT SPENT ON FOOD
VALUE_F_H                       =   0x11
VALUE_F1                        =   0x12    ; F1 = FLAG FOR CLEARING SOUTH PASS
VALUE_F2                        =   0x13    ; F2 = FLAG FOR CLEARING BLUE MOUNTAINS
VALUE_F9                        =   0x14    ; F9 = FRACTION OF 2 WEEKS TRAVELED ON FINAL TURN
VALUE_X5                        =   0x15    ; X5 = FLAG FOR INJURY
VALUE_L1                        =   0x16    ; L1 = FLAG FOR BLIZZARD
VALUE_M_L                       =   0x17    ; M  = TOTAL MILEAGE WHOLE TRIP
VALUE_M_H                       =   0x18
VALUE_M1_L                      =   0x19    ; M1 = AMOUNT SPENT ON MISCELLANEOUS SUPPLIES
VALUE_M1_H                      =   0x1a
VALUE_M2_L                      =   0x1b    ; M2 = MILEAGE UP THROUGH PREVIOUS TURN
VALUE_M2_H                      =   0x1c
VALUE_M9                        =   0x1d    ; M9 = FLAG FOR CLEARING SOUTH PASS IN SETTING MILEAGE
VALUE_P                         =   0x1e    ; P  = AMOUNT SPENT ON ITEMS AT FORT
VALUE_R1                        =   0x1f    ; R1 = RANDOM NUMBER IN CHOOSING EVENTS
VALUE_S4                        =   0x20    ; S4 = FLAG FOR ILLNESS
VALUE_S5                        =   0x21    ; S5 = ""HOSTILITY OF RIDERS"" FACTOR
VALUE_S6                        =   0x22    ; S6 = SHOOTING WORD SELECTOR
VALUE_S_0                       =   0x23    ; S$ = VARIATIONS OF SHOOTING WORD
VALUE_S_1                       =   0x24
VALUE_S_2                       =   0x25
VALUE_S_3                       =   0x26
VALUE_S_END                     =   0x27
VALUE_T_L                       =   0x28    ; T  = CASH LEFT OVER AFTER INITIAL PURCHASES
VALUE_T_H                       =   0x29
VALUE_T1                        =   0x2a    ; T1 = CHOICE OF TACTICS WHEN ATTACKED
VALUE_X                         =   0x2b    ; X  = CHOICE OF ACTION FOR EACH TURN
VALUE_X1                        =   0x2c    ; X1 = FLAG FOR FORT OPTION
VALUE_K8                        =   0x2d    ; K8 = CAUSE OF DIE
VALUE_LENGTH                    =   0x2e
VALUE_NULL                      =   0x00

; 外部関数宣言
;

    .globl  _ValueInitialize

; 外部変数宣言
;

    .globl  _value
