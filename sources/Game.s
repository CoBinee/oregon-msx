; Game.s : ゲーム
;


; モジュール宣言
;
    .module Game

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include	"Game.inc"
    .include    "Value.inc"
    .include    "Back.inc"

; 外部変数宣言
;
    .globl  _patternTable

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; ゲームを初期化する
;
_GameInitialize::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite
    
    ; パターンネームのクリア
    xor     a
    call    _SystemClearPatternName
    
    ; ゲームの初期化
    ld      hl, #gameDefault
    ld      de, #_game
    ld      bc, #GAME_LENGTH
    ldir

    ; 変数の初期化
    call    _ValueInitialize

    ; 背景の初期化
    call    _BackInitialize

    ; 転送の設定
    ld      hl, #_SystemUpdatePatternName
    ld      (_transfer), hl

    ; 描画の開始
    ld      hl, #(_videoRegister + VDP_R1)
    set     #VDP_R1_BL, (hl)
    
    ; 処理の設定
    ld      hl, #_Instruction
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 状態の設定
    ld      a, #APP_STATE_GAME_UPDATE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ゲームを更新する
;
_GameUpdate::
    
    ; レジスタの保存
    
    ; スプライトのクリア
    call    _SystemClearSprite

    ; カーソルの更新
    call    GameUpdateCursor

    ; 状態別の処理
    ld      hl, #10$
    push    hl
    ld      hl, (_game + GAME_PROC_L)
    jp      (hl)
;   pop     hl
10$:

    ; 背景の更新
    call    _BackUpdate

    ; 出力の更新
    call    GameUpdatePrint
    call    _GameIsPrint
    jr      nc, 29$

    ; 選択の更新
    call    GameUpdateSelect

    ; 数値の更新
    call    GameUpdateAmount

    ; ページ送りの更新
    call    GameUpdateFeed

    ; 射撃の更新
    call    GameUpdateBang

    ; 更新の完了
29$:

    ;; デバッグの表示
;   call    GamePrintDebug

    ; フレームの更新
    ld      hl, #(_game + GAME_FRAME)
    inc     (hl)

    ; レジスタの復帰
    
    ; 終了
    ret

; 何もしない
;
GameNull:

    ; レジスタの保存

    ; レジスタの復帰

    ; 終了
    ret

; VRAM へ転送する
;
GameTransfer:

    ; レジスタの保存

    ; d < ポート #0
    ; e < ポート #1

    ; レジスタの復帰

    ; 終了
    ret

; 文字列をクリアする
;
_GameClearString::

    ; レジスタの保存

    ; 文字列のクリア
    xor     a
    ld      (gameString), a

    ; レジスタの復帰

    ; 終了
    ret

; 文字列を取得する
;
_GameGetString::

    ; レジスタの保存

    ; hl > 文字列

    ; 文字列の取得
    ld      hl, #gameString

    ; レジスタの復帰

    ; 終了
    ret

; 文字列を連結する
;
_GameConcatString::

    ; レジスタの保存
    push    de

    ; hl < 文字列
    ; hl > 文字列

    ; 文字列の複写
    ld      de, #gameString
10$:
    ld      a, (de)
    or      a
    jr      z, 11$
    inc     de
    jr      10$
11$:
    ld      a, (hl)
    ld      (de), a
    inc     hl
    inc     de
    or      a
    jr      nz, 11$
    ld      hl, #gameString

    ; レジスタの復帰
    pop     de

    ; 終了
    ret

; 数値を連結する
;
_GameConcatValue::

    ; レジスタの保存
    push    bc
    push    de

    ; hl < 数値
    ;  b < 桁数（0 で左詰め）
    ; hl > 文字列

    ; 数値の文字列化
    ld      de, #gameValue
    call    _AppGetDecimal16

    ; 文字列の末端の取得
    ld      de, #gameString
10$:
    ld      a, (de)
    or      a
    jr      z, 19$
    inc     de
    jr      10$
19$:

    ; 左詰めの複写
20$:
    ld      a, b
    or      a
    jr      nz, 30$
    ld      hl, #gameValue
    ld      b, #0x04
21$:
    ld      a, (hl)
    or      a
    jr      nz, 22$
    inc     hl
    djnz    21$
22$:
    inc     b
23$:
    ld      a, (hl)
    add     a, #___0
    ld      (de), a
    inc     hl
    inc     de
    djnz    23$
    jr      90$

    ; 右詰めの描画
30$:
    ld      hl, #gameValue
    ld      a, #0x05
    sub     b
    jr      z, 32$
31$:
    inc     hl
    dec     a
    jr      nz, 31$
32$:
    dec     b
    jr      z, 34$
33$:
    ld      a, (hl)
    or      a
    jr      nz, 34$
    ld      a, #____
    ld      (de), a
    inc     hl
    inc     de
    djnz    33$
34$:
    inc     b
35$:
    ld      a, (hl)
    add     a, #___0
    ld      (de), a
    inc     hl
    inc     de
    djnz    35$
;   jr      90$

    ; 複写の完了
90$:
    xor     a
    ld      (de), a
    ld      hl, #gameString

    ; レジスタの復帰
    pop     de
    pop     bc

    ; 終了
    ret

; カーソルをクリアする
;
GameClearCursor:

    ; レジスタの保存

    ; 入力の設定
    xor     a
    ld      (_game + GAME_CURSOR), a
    ld      (_game + GAME_CURSOR_UP), a
    ld      (_game + GAME_CURSOR_DOWN), a
    ld      (_game + GAME_CURSOR_LEFT), a
    ld      (_game + GAME_CURSOR_RIGHT), a

    ; レジスタの復帰

    ; 終了
    ret

; カーソルを更新する
;
GameUpdateCursor:

    ; レジスタの保存

    ; カーソルのクリア
    ld      c, #0x00

    ; ↑ の更新
    ld      hl, #(_game + GAME_CURSOR_UP)
    ld      a, (_input + INPUT_KEY_UP)
    or      a
    jr      nz, 10$
    ld      (hl), a
    jr      19$
10$:
    inc     (hl)
    ld      a, (hl)
    cp      #0x01
    jr      z, 11$
    cp      #GAME_CURSOR_INTERVAL_0
    jr      z, 12$
    cp      #(GAME_CURSOR_INTERVAL_0 + GAME_CURSOR_INTERVAL_1)
    jr      c, 19$
    ld      (hl), #GAME_CURSOR_INTERVAL_0
    jr      12$
11$:
    set     #GAME_CURSOR_UP_EDGE_BIT, c
12$:
    set     #GAME_CURSOR_UP_REPEAT_BIT, c
;   jr      19$    
19$:

    ; ↓ の更新
    ld      hl, #(_game + GAME_CURSOR_DOWN)
    ld      a, (_input + INPUT_KEY_DOWN)
    or      a
    jr      nz, 20$
    ld      (hl), a
    jr      29$
20$:
    inc     (hl)
    ld      a, (hl)
    cp      #0x01
    jr      z, 21$
    cp      #GAME_CURSOR_INTERVAL_0
    jr      z, 22$
    cp      #(GAME_CURSOR_INTERVAL_0 + GAME_CURSOR_INTERVAL_1)
    jr      c, 29$
    ld      (hl), #GAME_CURSOR_INTERVAL_0
    jr      22$
21$:
    set     #GAME_CURSOR_DOWN_EDGE_BIT, c
22$:
    set     #GAME_CURSOR_DOWN_REPEAT_BIT, c
;   jr      29$    
29$:

    ; ← の更新
    ld      hl, #(_game + GAME_CURSOR_LEFT)
    ld      a, (_input + INPUT_KEY_LEFT)
    or      a
    jr      nz, 30$
    ld      (hl), a
    jr      39$
30$:
    inc     (hl)
    ld      a, (hl)
    cp      #0x01
    jr      z, 31$
    cp      #GAME_CURSOR_INTERVAL_0
    jr      z, 32$
    cp      #(GAME_CURSOR_INTERVAL_0 + GAME_CURSOR_INTERVAL_1)
    jr      c, 39$
    ld      (hl), #GAME_CURSOR_INTERVAL_0
    jr      32$
31$:
    set     #GAME_CURSOR_LEFT_EDGE_BIT, c
32$:
    set     #GAME_CURSOR_LEFT_REPEAT_BIT, c
;   jr      39$    
39$:

    ; → の更新
    ld      hl, #(_game + GAME_CURSOR_RIGHT)
    ld      a, (_input + INPUT_KEY_RIGHT)
    or      a
    jr      nz, 40$
    ld      (hl), a
    jr      49$
40$:
    inc     (hl)
    ld      a, (hl)
    cp      #0x01
    jr      z, 41$
    cp      #GAME_CURSOR_INTERVAL_0
    jr      z, 42$
    cp      #(GAME_CURSOR_INTERVAL_0 + GAME_CURSOR_INTERVAL_1)
    jr      c, 49$
    ld      (hl), #GAME_CURSOR_INTERVAL_0
    jr      42$
41$:
    set     #GAME_CURSOR_RIGHT_EDGE_BIT, c
42$:
    set     #GAME_CURSOR_RIGHT_REPEAT_BIT, c
;   jr      49$    
49$:

    ; カーソルの更新
    ld      a, c
    ld      (_game + GAME_CURSOR), a

    ; レジスタの復帰

    ; 終了
    ret

; 文字列を出力する
;
_GamePrint::

    ; レジスタの保存

    ; hl < 文字列

    ; 文字列の設定
    ld      a, (hl)
    or      a
    jr      z, 19$
    ld      (_game + GAME_PRINT_STRING_L), hl
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 出力が終わったかどうかを判定する
;
_GameIsPrint::

    ; レジスタの保存
    push    hl

    ; cf > 1 = 出力が終わった

    ; 出力の判定
    ld      a, (_game + GAME_PRINT_SCROLL)
    or      a
    jr      nz, 18$
    ld      hl, (_game + GAME_PRINT_STRING_L)
    ld      a, h
    or      l
    jr      nz, 18$
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 出力を更新する
;
GameUpdatePrint:

    ; レジスタの保存

    ; 出力の更新
    ld      hl, #(_game + GAME_PRINT_SCROLL)
    ld      a, (hl)
    or      a
    jr      z, 10$
    dec     (hl)
    call    GameScrollLine
    jr      19$
10$:
    call    GameOutputPrint
;   jr      19$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; １文字を出力する
;
GameOutputPrint:

    ; レジスタの保存

    ; １文字の描画
    ld      de, (_game + GAME_PRINT_STRING_L)
    ld      a, d
    or      e
    jp      z, 190$
    ld      hl, (_game + GAME_PRINT_LOCATE_L)
100$:
    ld      a, (de)
    or      a
    jr      nz, 101$
    call    170$
    ld      de, #0x0000
    jr      109$
101$:
    cp      #__LF
    jr      nz, 102$
    call    170$
    inc     de
    ld      a, (de)
    or      a
    jr      z, 108$
    jr      109$
102$:
    cp      #____
    jr      nz, 103$
    inc     hl
    inc     de
    call    180$
    jr      c, 109$
    jr      100$
103$:
    push    hl
    ld      bc, #_patternName
    add     hl, bc
    ld      (hl), a
    pop     hl
    inc     hl
    inc     de
    ld      a, (de)
    cp      #_KSN
    jr      z, 104$
    cp      #_KPS
    jr      z, 104$
    jr      105$
104$:
    push    hl
    ld      bc, #(_patternName - 0x0021)
    add     hl, bc
    ld      (hl), a
    pop     hl
    inc     de
105$:
    call    180$
    jr      c, 109$
    ld      a, (de)
    or      a
    jr      z, 108$
    jr      109$
108$:
    call    170$
    ld      de, #0x0000
;   jr      109$
109$:
    ld      (_game + GAME_PRINT_LOCATE_L), hl
    ld      (_game + GAME_PRINT_STRING_L), de
    jr      190$
170$:
    ld      a, l
    and     #0x1f
    jr      z, 171$
    ld      a, l
    and     #0xe0
    ld      l, a
    ld      bc, #0x0040
    add     hl, bc
171$:
    call    180$
    ret
180$:
    ld      bc, #(0x0018 * 0x0020)
    or      a
    sbc     hl, bc
    jr      nc, 181$
    add     hl, bc
    or      a
    jr      189$
181$:
    ld      a, #0x02
    ld      (_game + GAME_PRINT_SCROLL), a
    scf
;   jr      189$
189$:
    ret
190$:

    ; レジスタの復帰

    ; 終了
    ret

; 画面をスクロールさせる
;
_GameScroll::

    ; レジスタの保存
    
    ; a < スクロールする行

    ; スクロールの設定
    ld      (_game + GAME_PRINT_SCROLL), a

    ; レジスタの復帰

    ; 終了
    ret

; １行スクロールする
;
GameScrollLine:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; スクロール
    ld      hl, #(_patternName + 5 * 0x0020)
    ld      de, #(_patternName + 4 * 0x0020)
    ld      bc, #(19 * 0x0020)
    ldir
    ld      hl, #(_patternName + 23 * 0x0020 + 0x0000)
    ld      de, #(_patternName + 23 * 0x0020 + 0x0001)
    ld      bc, #(0x0020 - 0x0001)
    ld      (hl), #____
    ldir
    ld      hl, #(23 * 0x0020)
    ld      (_game + GAME_PRINT_LOCATE_L), hl

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 選択を設定する
;
_GameSelect::

    ; レジスタの保存
    push    hl

    ; hl < 文字列テーブル
    ; a  < 数

    ; 選択の設定
    ld      (_game + GAME_SELECT_L), hl
    ld      (_game + GAME_SELECT_SIZE), a
    xor     a
    ld      (_game + GAME_SELECT_ITEM), a

    ; カーソルのクリア
    call    GameClearCursor

    ; フラグの設定
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_SELECT_BIT, (hl)

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 選択された項目を取得する
;
_GameGetSelectItem::

    ; レジスタの保存

    ; a  > 項目
    ; cf > 1 = 選択された

    ; 項目の取得
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_SELECT_BIT, a
    jr      nz, 18$
    ld      a, (_game + GAME_SELECT_ITEM)
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 選択を更新する
;
GameUpdateSelect:

    ; レジスタの保存

    ; 選択の存在
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_SELECT_BIT, a
    jr      z, 90$

    ; 出力の監視
    call    _GameIsPrint
    jr      nc, 90$

    ; 選択の決定
10$:
    ld      hl, #(_game + GAME_SELECT_ITEM)
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 20$
    ld      hl, #(_game + GAME_FLAG)
    res     #GAME_FLAG_SELECT_BIT, (hl)
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    ld      a, #0x02
    ld      (_game + GAME_PRINT_SCROLL), a
    jr      80$

    ; 前の項目
20$:
    ld      a, (_game + GAME_CURSOR)
    and     #(GAME_CURSOR_UP_EDGE | GAME_CURSOR_LEFT_EDGE)
    jr      z, 30$
    ld      a, (hl)
    or      a
    jr      z, 80$
    dec     (hl)
    jr      80$

    ; 次の項目
30$:
    ld      a, (_game + GAME_CURSOR)
    and     #(GAME_CURSOR_DOWN_EDGE | GAME_CURSOR_RIGHT_EDGE)
    jr      z, 80$
    ld      a, (_game + GAME_SELECT_SIZE)
    dec     a
    cp      (hl)
    jr      z, 80$
    inc     (hl)
;   jr      80$

    ; 選択の表示
80$:
    call    GameOutputSelect

    ; 選択の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 選択を表示する
;
GameOutputSelect:

    ; レジスタの保存

    ; 最下行をクリア
    ld      hl, #(_patternName + 22 * 0x0020 + 0x0000)
    ld      de, #(_patternName + 22 * 0x0020 + 0x0001)
    ld      bc, #(2 * 0x0020 - 0x0001)
    ld      (hl), #____
    ldir

    ; プロンプトの描画
    ld      hl, #(_patternName + 23 * 0x0020)
    ld      (hl), #_PRT

    ; 選択肢の描画
    ld      a, (_game + GAME_SELECT_ITEM)
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, (_game + GAME_SELECT_L)
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      hl, #(_patternName + 23 * 0x0020 + 2)
10$:
    ld      a, (de)
    or      a
    jr      z, 19$
    inc     de
    cp      #_KSN
    jr      z, 11$
    cp      #_KPS
    jr      z, 11$
    ld      (hl), a
    inc     hl
    jr      10$
11$:
    push    hl
    ld      bc, #-0x0021
    add     hl, bc
    ld      (hl), a
    pop     hl
    jr      10$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 数値を入力する
;
_GameAmount::

    ; レジスタの保存
    push    hl

    ; hl < 最大値
    ; de < 最小値

    ; 数値の設定
    ld      (_game + GAME_AMOUNT_L), de
    ld      (_game + GAME_AMOUNT_MINIMUM_L), de
    ld      (_game + GAME_AMOUNT_MAXIMUM_L), hl

    ; カーソルのクリア
    call    GameClearCursor

    ; フラグの設定
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_AMOUNT_BIT, (hl)

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 数値を取得する
;
_GameGetAmountValue::

    ; レジスタの保存

    ; hl > 数値
    ; cf > 1 = 決定した

    ; 数値の取得
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_AMOUNT_BIT, a
    jr      nz, 18$
    ld      hl, (_game + GAME_AMOUNT_L)
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 数値を更新する
;
GameUpdateAmount:

    ; レジスタの保存

    ; 数値の存在
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_AMOUNT_BIT, a
    jr      z, 90$

    ; 出力の監視
    call    _GameIsPrint
    jr      nc, 90$

    ; 数値の決定
10$:
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 20$
    ld      hl, #(_game + GAME_FLAG)
    res     #GAME_FLAG_AMOUNT_BIT, (hl)
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    ld      a, #0x02
    ld      (_game + GAME_PRINT_SCROLL), a
    jr      80$

    ; 数値の増加
20$:
    ld      hl, (_game + GAME_AMOUNT_L)
    ld      a, (_game + GAME_CURSOR)
    bit     #GAME_CURSOR_LEFT_REPEAT_BIT, a
    jr      z, 21$
    ld      de, #10
    add     hl, de
    jr      22$
21$:
    bit     #GAME_CURSOR_UP_REPEAT_BIT, a
    jr      z, 30$
    inc     hl
22$:
    ld      de, (_game + GAME_AMOUNT_MAXIMUM_L)
    or      a
    sbc     hl, de
    jr      nc, 23$
    add     hl, de
    jr      24$
23$:
    ex      de, hl
24$:
    ld      (_game + GAME_AMOUNT_L), hl
    jr      80$

    ; 数値の減少
30$:
    ld      hl, (_game + GAME_AMOUNT_L)
    ld      a, (_game + GAME_CURSOR)
    bit     #GAME_CURSOR_RIGHT_REPEAT_BIT, a
    jr      z, 31$
    ld      de, #10
    jr      32$
31$:
    bit     #GAME_CURSOR_DOWN_REPEAT_BIT, a
    jr      z, 80$
    ld      de, #1
32$:
    or      a
    sbc     hl, de
    jr      nc, 33$
    ld      hl, #0x0000
33$:
    ld      de, (_game + GAME_AMOUNT_MINIMUM_L)
    ld      a, d
    or      e
    jr      z, 35$
    or      a
    sbc     hl, de
    jr      c, 34$
    add     hl, de
    jr      35$
34$:
    ex      de, hl
35$:
    ld      (_game + GAME_AMOUNT_L), hl
;   jr      80$

    ; 数値の表示
80$:
    call    GameOutputAmount

    ; 選択の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 数値を表示する
;
GameOutputAmount:

    ; レジスタの保存

    ; 最下行をクリア
    ld      hl, #(_patternName + 23 * 0x0020 + 0x0000)
    ld      de, #(_patternName + 23 * 0x0020 + 0x0001)
    ld      bc, #(0x0020 - 0x0001)
    ld      (hl), #____
    ldir

    ; プロンプトの描画
    ld      hl, #(_patternName + 23 * 0x0020)
    ld      (hl), #_PRT

    ; 数値の描画
    ld      hl, (_game + GAME_AMOUNT_L)
    ld      de, #(_patternName + 23 * 0x0020 + 2)
    ld      b, #0x00
    call    _GamePrintValue

    ; レジスタの復帰

    ; 終了
    ret

; ページ送りする
;
_GameFeed::

    ; レジスタの保存
    push    hl

    ; フラグの設定
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_FEED_BIT, (hl)

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; ページ送りされたかどうかを判定する
;
_GameIsFeed::

    ; レジスタの保存

    ; cf > 1 = 送られた

    ; フラグの判定
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_FEED_BIT, a
    jr      nz, 18$
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; ページ送りを更新する
;
GameUpdateFeed:

    ; レジスタの保存
    push    hl

    ; ページ送りの存在
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_FEED_BIT, a
    jr      z, 19$

    ; 出力の監視
    call    _GameIsPrint
    jr      nc, 19$

    ; SPACE キーの押下
    ld      a, (_input + INPUT_BUTTON_SPACE)
    dec     a
    jr      nz, 10$
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe

    ; フラグの更新
    ld      hl, #(_game + GAME_FLAG)
    res     #GAME_FLAG_FEED_BIT, (hl)

    ; ページ送りの消去
    ld      hl, #(_patternName + 23 * 0x0020 + 15)
    ld      (hl), #____
    jr      19$

    ; ページ送りの表示
10$:
    ld      hl, #(_patternName + 23 * 0x0020 + 15)
    ld      (hl), #_FED
;   jr      19$
19$:

    ; レジスタの復帰
    pop     hl

    ; 終了
    ret

; 射撃を行う
;
_GameBang::

    ; レジスタの保存

    ; カーソルの設定
    ld      hl, #(_value + VALUE_S_0)
    ld      b, #0x04
10$:
    call    _SystemGetRandom
    and     #0x03
    add     a, #__UP
    ld      (hl), a
    inc     hl
    djnz    10$
    xor     a
    ld      (_value + VALUE_S_END), a

    ; カウントの設定
    xor     a
    ld      (_game + GAME_COUNT), a

    ; タイマの設定
    ld      hl, #0x0000
    ld      (_value + VALUE_B1_L), hl

    ; フラグの設定
    ld      hl, #(_game + GAME_FLAG)
    set     #GAME_FLAG_BANG_BIT, (hl)

    ; レジスタの復帰

    ; 終了
    ret

; 射撃が終わったかどうかを判定する
;
_GameIsBang::

    ; レジスタの保存

    ; cf > 1 = 射撃の完了

    ; スクロールの判定
    call    _GameIsPrint
    jr      nc, 18$

    ; フラグの判定
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_BANG_BIT, a
    jr      nz, 18$
    scf
    jr      19$
18$:
    or      a
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 射撃を更新する
;
GameUpdateBang:

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; 射撃の存在
    ld      a, (_game + GAME_FLAG)
    bit     #GAME_FLAG_BANG_BIT, a
    jp      z, 90$

    ; タイマの更新
    ld      hl, (_value + VALUE_B1_L)
    inc     hl
    ld      a, h
    or      l
    jr      z, 10$
    ld      (_value + VALUE_B1_L), hl
10$:

    ; カーソルの取得
    ld      a, (_game + GAME_COUNT)
    ld      e, a
    ld      d, #0x00
    ld      hl, #(_value + VALUE_S_0)
    add     hl, de
    ld      a, (hl)

    ; ↑
    cp      #__UP
    jr      nz, 11$
    ld      a, (_input + INPUT_KEY_UP)
    dec     a
    jr      z, 14$
    jr      80$

    ; ↓
11$:
    cp      #_DWN
    jr      nz, 12$
    ld      a, (_input + INPUT_KEY_DOWN)
    dec     a
    jr      z, 14$
    jr      80$

    ; ←
12$:
    cp      #_LFT
    jr      nz, 13$
    ld      a, (_input + INPUT_KEY_LEFT)
    dec     a
    jr      z, 14$
    jr      80$

    ; →
13$:
;   cp      #_RGT
;   jr      nz, 14$
    ld      a, (_input + INPUT_KEY_RIGHT)
    dec     a
    jr      z, 14$
    jr      80$

    ; 正しく入力
14$:
    ld      hl, #(_game + GAME_COUNT)
    inc     (hl)
    ld      a, #SOUND_SE_OK
    call    _SoundPlaySe
    ld      a, (_game + GAME_COUNT)
    cp      #0x04
    jr      c, 80$

    ; 秒単位での計測
    ld      hl, (_value + VALUE_B1_L)
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l
    srl     h
    rr      l
    ld      a, (_value + VALUE_D9)
    dec     a
    ld      e, a
    ld      d, #0x00
    or      a
    sbc     hl, de
    jr      nc, 15$
    ld      hl, #0x0000
15$:
    ld      de, #100
    or      a
    sbc     hl, de
    jr      nc, 16$
    add     hl, de
    jr      17$
16$:
    ex      de, hl
17$:
    ld      (_value + VALUE_B1_L), hl

    ; フラグの更新
    ld      hl, #(_game + GAME_FLAG)
    res     #GAME_FLAG_BANG_BIT, (hl)

    ; スクロールの設定
    ld      a, #0x02
    call    _GameScroll
;   jr      80$

    ; カーソルの表示
80$:
    call    _GameClearString
    ld      hl, #gameBangString_0
    call    _GameConcatString
    ld      hl, #(_value + VALUE_S_0)
    call    _GameConcatString
    ld      hl, #gameBangString_1
    call    _GameConcatString
81$:
    ld      a, (hl)
    inc     hl
    or      a
    jr      nz, 81$
    dec     hl
    ld      de, #(_value + VALUE_S_0)
    ld      a, (_game + GAME_COUNT)
    or      a
    jr      z, 83$
    ld      b, a
82$:
    ld      a, (de)
    ld      (hl), a
    inc     de
    inc     hl
    djnz    82$
83$:
    ld      (hl), #0x00
    call    _GameGetString
    ld      de, #(_patternName + 23 * 0x0020 + 0)
    call    _GamePrintString

    ; 射撃の完了
90$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 文字列を表示する
;
_GamePrintString::

    ; レジスタの保存

    ; hl < 文字列
    ; de < 表示位置

    ; 文字列の描画
10$:
    ld      c, e
    ld      b, d
11$:
    ld      a, (hl)
    or      a
    jr      z, 19$
    cp      #__LF
    jr      z, 12$
    ld      (de), a
    inc     hl
    inc     de
    jr      11$
12$:
    ld      e, c
    ld      d, b
    ex      de, hl
    ld      bc, #0x0020
    add     hl, bc
    ex      de, hl
    jr      10$
19$:

    ; レジスタの復帰

    ; 終了
    ret

; 数値を表示する
;
_GamePrintValue::

    ; レジスタの保存
    push    hl
    push    bc
    push    de

    ; hl < 数値
    ; de < 表示位置
    ; b  < 桁数（0 で左詰め）

    ; 数値の変換
    push    de
    ld      de, #gameValue
    call    _AppGetDecimal16
    pop     de

    ; 左詰めの描画
10$:
    ld      a, b
    or      a
    jr      nz, 20$
    ld      hl, #gameValue
    ld      b, #0x04
11$:
    ld      a, (hl)
    or      a
    jr      nz, 12$
    inc     hl
    djnz    11$
12$:
    inc     b
13$:
    ld      a, (hl)
    add     a, #___0
    ld      (de), a
    inc     hl
    inc     de
    djnz    13$
    jr      90$

    ; 右詰めの描画
20$:
    ld      hl, #gameValue
    ld      a, #0x05
    sub     b
    jr      z, 22$
21$:
    inc     hl
    dec     a
    jr      nz, 21$
22$:
    dec     b
    jr      z, 24$
23$:
    ld      a, (hl)
    or      a
    jr      nz, 24$
    ld      a, #____
    ld      (de), a
    inc     hl
    inc     de
    djnz    23$
24$:
    inc     b
25$:
    ld      a, (hl)
    add     a, #___0
    ld      (de), a
    inc     hl
    inc     de
    djnz    25$
;   jr      90$

    ; 表示の完了
90$:

    ; レジスタの復帰
    pop     de
    pop     bc
    pop     hl

    ; 終了
    ret

; 16 bits / 8 bits の除算を行う
;
_GameDiv::

    ; レジスタの保存
    push    bc

    ; hl < 割られる数
    ; a  < 割る数
    ; hl > 商
    ; a  > 余り

    ; 除算
    ld      c, a
    ld      b, #16
    xor     a
10$:
    add     hl, hl
    rla
    cp      c
    jr      c, 11$
    sub     c
    inc     l
11$:
    djnz    10$

    ; レジスタの復帰
    pop     bc

    ; 終了
    ret

; デバッグを表示する
;
GamePrintDebug:

    ; レジスタの保存

    ; 値の表示
    ld      hl, #gameDebugString_0
    ld      de, #(_patternName + 0 * 0x0020 + 0)
    call    _GamePrintString
    ld      hl, (_value + VALUE_M_L)
    ld      de, #(_patternName + 0 * 0x0020 + 2)
    ld      b, #5
    call    _GamePrintValue
    ld      hl, (_value + VALUE_T_L)
    ld      de, #(_patternName + 0 * 0x0020 + 10)
    ld      b, #5
    call    _GamePrintValue
    ld      hl, (_value + VALUE_A_L)
    ld      de, #(_patternName + 0 * 0x0020 + 18)
    ld      b, #5
    call    _GamePrintValue
    ld      hl, #gameDebugString_1
    ld      de, #(_patternName + 1 * 0x0020 + 0)
    call    _GamePrintString
    ld      hl, (_value + VALUE_F_L)
    ld      de, #(_patternName + 1 * 0x0020 + 2)
    ld      b, #5
    call    _GamePrintValue
    ld      hl, (_value + VALUE_B_L)
    ld      de, #(_patternName + 1 * 0x0020 + 10)
    ld      b, #5
    call    _GamePrintValue
    ld      hl, (_value + VALUE_C_L)
    ld      de, #(_patternName + 1 * 0x0020 + 18)
    ld      b, #5
    call    _GamePrintValue
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #(_patternName + 1 * 0x0020 + 26)
    ld      b, #5
    call    _GamePrintValue

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; ゲームの初期値
;
gameDefault:

    .dw     GAME_PROC_NULL
    .db     GAME_STATE_NULL
    .db     GAME_FLAG_NULL
    .db     GAME_FRAME_NULL
    .db     GAME_COUNT_NULL
    .db     GAME_CURSOR_NULL
    .db     GAME_CURSOR_NULL
    .db     GAME_CURSOR_NULL
    .db     GAME_CURSOR_NULL
    .db     GAME_CURSOR_NULL
    .dw     23 * 0x0020 ; GAME_PRINT_NULL
    .dw     GAME_PRINT_NULL
    .db     GAME_PRINT_NULL
    .dw     GAME_SELECT_NULL
    .db     GAME_SELECT_NULL
    .db     GAME_SELECT_NULL
    .dw     -1 ; GAME_AMOUNT_NULL
    .dw     GAME_AMOUNT_NULL
    .dw     GAME_AMOUNT_NULL

; 射撃
;
gameBangString_0:

    .db     ___T, ___Y, ___P, ___E, ____, 0x00

gameBangString_1:

    .db     ____, _PRT, ____, 0x00

; デバッグ
;
gameDebugString_0:

    .db     ___M, _COL, ____, ____, ____, ____, ____, ____
    .db     ___G, _COL, ____, ____, ____, ____, ____, ____
    .db     ___A, _COL, ____, ____, ____, ____, ____, ____
    .db     0x00

gameDebugString_1:

    .db     ___F, _COL, ____, ____, ____, ____, ____, ____
    .db     ___B, _COL, ____, ____, ____, ____, ____, ____
    .db     ___C, _COL, ____, ____, ____, ____, ____, ____
    .db     ___S, _COL, ____, ____, ____, ____, ____, ____
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

; ゲーム
;
_game::

    .ds     GAME_LENGTH

; 文字列
;
gameString:

    .ds     GAME_STRING_LENGTH

; 数値
gameValue:

    .ds     GAME_VALUE_LENGTH