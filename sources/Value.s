; Value.s : 変数
;


; モジュール宣言
;
    .module Value

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include	"Game.inc"
    .include	"Value.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 変数を初期化する
;
_ValueInitialize::

    ; レジスタの保存

    ; 変数の初期化
    ld      hl, #(_value + 0x0000)
    ld      de, #(_value + 0x0001)
    ld      bc, #(VALUE_LENGTH - 0x00001)
    ld      (hl), #0x00
    ldir

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;


; DATA 領域
;
    .area   _DATA

; 変数
;
_value::

    .ds     VALUE_LENGTH
