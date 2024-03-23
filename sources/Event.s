; Event.s : イベント
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

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; イベントが発生する
;
_Event::
    
    ; レジスタの保存

    ; イベントの発生
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #100
    call    _GameDiv
    ld      (_value + VALUE_R1), a
    ld      hl, #eventTable
    ld      b, #0x01
10$:
    cp      (hl)
    jr      c, 11$
    inc     hl
    inc     b
    jr      10$
11$:
    ld      a, b
    ld      (_value + VALUE_D1), a
    dec     a
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #eventProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      (_game + GAME_PROC_L), de
    xor     a
    ld      (_game + GAME_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret
    
; 幌馬車が壊れる
;
EventBreakWagon:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventBreakWagonString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 進行の停滞
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #5
    call    _GameDiv
    add     a, #15
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 必需品の消費
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #8
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 牛が足を怪我する
;
EventInjureOxLeg:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventInjureOxLegString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #25
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 牛の消耗
    ld      hl, (_value + VALUE_A_L)
    ld      de, #20
    or      a
    sbc     hl, de
    ld      (_value + VALUE_A_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 娘が腕を骨折する
;
EventBreakDaughterArm:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventBreakDaughterArmString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 進行の停滞
    call    _SystemGetRandom
    and     #0x03
    add     a, #5
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 必需品の消費
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #3
    call    _GameDiv
    add     a, #2
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M1_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 牛が逸れる
;
EventWanderOffOx:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventWanderOffOxString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #17
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 息子が迷子になる
;
EventLostSon:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventLostSonString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #10
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 水が足りない
;
EventUnsafeWater:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventUnsafeWaterString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 進行の停滞
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #10
    call    _GameDiv
    add     a, #2
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 大雨が降る
;
EventHeavyRain:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 950 マイル以上は寒波
    ld      hl, (_value + VALUE_M_L)
    ld      de, #(950 + 1)
    or      a
    sbc     hl, de
    jr      c, 00$
    ld      hl, #EventColdWeather
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$

    ; イベントの表示
00$:
    ld      hl, #eventHeavyRainString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 食料の消失
    ld      hl, (_value + VALUE_F_L)
    ld      de, #10
    or      a
    sbc     hl, de
    ld      (_value + VALUE_F_L), hl

    ; 弾薬の消失
    ld      hl, (_value + VALUE_B_L)
    ld      de, #500
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 必需品の消失
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #15
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 進行の停滞
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #10
    call    _GameDiv
    add     a, #5
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 山賊が襲ってくる
;
EventAttackBandit:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventAttackBanditBangString
    call    _GamePrint

    ; 射撃
    call    _GameBang

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 射撃
10$:
    ld      a, (_game + GAME_STATE)
    dec     a
    jr      nz, 20$

    ; 射撃の監視
    call    _GameIsBang
    jp      nc, 90$

    ; 弾薬の消費
    ld      hl, (_value + VALUE_B1_L)
    add     hl, hl
    add     hl, hl
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, hl
    add     hl, de
    ex      de, hl
    ld      hl, (_value + VALUE_B_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 弾薬を撃ち尽くした
    bit     #0x07, h
    jr      z, 11$
    ld      hl, #eventAttackBanditLostCashString
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
11$:
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 結果
20$:
    dec     a
    jr      nz, 30$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; お金の紛失
    ld      a, (_value + VALUE_B_H)
    bit     #0x07, a
    jr      z, 21$
    ld      hl, (_value + VALUE_T_L)
    ld      a, #3
    call    _GameDiv
    ld      (_value + VALUE_T_L), hl
21$:

    ; 山賊を追い払う
    ld      hl, (_value + VALUE_B1_L)
    ld      de, #(1 + 1)
    or      a
    sbc     hl, de
    jr      nc, 22$
    ld      hl, #eventAttackBanditSuccessString
    jr      23$

    ; 負傷する
22$:
    ld      a, #0x01
    ld      (_value + VALUE_K8), a

    ; 牛の消耗
    ld      hl, (_value + VALUE_A_L)
    ld      de, #20
    or      a
    sbc     hl, de
    ld      (_value + VALUE_A_L), hl

    ; 必需品の紛失
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #5
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 結果の表示
    ld      hl, #eventAttackBanditLostOxenString
23$:
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x03 : ページ送り
30$:
;   dec     a
;   jr      nz, 40$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 幌馬車で小火が起こる
;
EventFireWagon:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventFireWagonString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 食料の消失
    ld      hl, (_value + VALUE_F_L)
    ld      de, #40
    or      a
    sbc     hl, de
    ld      (_value + VALUE_F_L), hl

    ; 弾薬の消失
    ld      hl, (_value + VALUE_B_L)
    ld      de, #400
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 必需品の消失
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #68
    call    _GameDiv
    add     a, #3
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M1_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #15
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 濃霧で道に迷う
;
EventHeavyFog:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventHeavyFogString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 進行の停滞
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #5
    call    _GameDiv
    add     a, #10
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 毒蛇に噛まれる
;
EventBitPoisonSnake:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventBitPoisonSnakeBitString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
    ld      a, (_game + GAME_STATE)
    dec     a
    jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 弾薬の消費
    ld      hl, (_value + VALUE_B_L)
    ld      de, #10
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 必需品の消費
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #5
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 生存
    bit     #0x07, h
    jr      nz, 11$
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$

    ; 死因の表示
11$:
    ld      hl, #eventBitPoisonSnakeDieString
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 死亡
20$:
;   dec     a
;   jr      nz, 30$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 処理の更新
    ld      hl, #_Die
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 川の浅瀬にはまる
;
EventSwampWagon:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventSwampWagonString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 食料の紛失
    ld      hl, (_value + VALUE_F_L)
    ld      de, #30
    or      a
    sbc     hl, de
    ld      (_value + VALUE_F_L), hl

    ; 衣類の紛失
    ld      hl, (_value + VALUE_C_L)
    ld      de, #20
    or      a
    sbc     hl, de
    ld      (_value + VALUE_C_L), hl

    ; 進行の停滞
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #20
    call    _GameDiv
    add     a, #20
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 野生の動物に襲われる
;
EventAttackWildAnimal:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventAttackWildAnimalBangString
    call    _GamePrint

    ; 射撃
    call    _GameBang

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 射撃
10$:
    ld      a, (_game + GAME_STATE)
    dec     a
    jr      nz, 20$

    ; 射撃の監視
    call    _GameIsBang
    jp      nc, 90$

    ; 弾薬が足りない
    ld      hl, (_value + VALUE_B_L)
    ld      de, #40
    or      a
    sbc     hl, de
    jp      p, 11$
    ld      a, #1
    ld      (_value + VALUE_K8), a
    ld      hl, #eventAttackWildAnimalDieString
    jr      18$

    ; 弾薬が足りた
11$:
    ld      hl, (_value + VALUE_B1_L)
    ld      de, #(2 + 1)
    or      a
    sbc     hl, de
    jr      nc, 12$
    ld      hl, #eventAttackWildAnimalNiceString
    jr      18$
12$:
    ld      hl, #eventAttackWildAnimalSlowString
;   jr      18$

    ; 出力
18$:
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : ページ送り
20$:
;   dec     a
;   jr      nz, 30$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 死亡した
    ld      a, (_value + VALUE_K8)
    or      a
    jr      z, 21$

    ; 処理の更新
    ld      hl, #_Die
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$

    ; 追い払った
21$:

    ; 弾薬の消費
    ld      hl, (_value + VALUE_B1_L)
    add     hl, hl
    add     hl, hl
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, hl
    add     hl, de
    ex      de, hl
    ld      hl, (_value + VALUE_B_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 衣類の消耗
    ld      hl, (_value + VALUE_B1_L)
    add     hl, hl
    add     hl, hl
    ex      de, hl
    ld      hl, (_value + VALUE_C_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_C_L), hl

    ; 食料の消耗
    ld      hl, (_value + VALUE_B1_L)
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ex      de, hl
    ld      hl, (_value + VALUE_F_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_F_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 寒波に見舞われる
;
EventColdWeather:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    call    _SystemGetRandom
    and     #0x03
    add     a, #(22 + 1)
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_C_L)
    or      a
    sbc     hl, de
    jr      c, 00$
    ld      hl, #eventColdWeatherEnoughClothString
    jr      01$
00$:
    ld      a, #1
    ld      (_value + VALUE_C1), a
    ld      hl, #eventColdWeatherNotEnoughClothString
01$:
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;  ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jp      nc, 90$

    ; 処理の更新
    ld      a, (_value + VALUE_C1)
    or      a
    jr      nz, 11$
    ld      hl, #EventNext
    jr      12$
11$:
    ld      hl, #_Illness
12$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 雹嵐に見舞われる
;
EventHailStorm:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventHailStromString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 進行の停滞
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #10
    call    _GameDiv
    add     a, #5
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 弾薬の消耗
    ld      hl, (_value + VALUE_B_L)
    ld      de, #200
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 必需品の消耗
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #3
    call    _GameDiv
    add     a, #4
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M1_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl
    
    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 病に冒される
;
EventIllness:
    
    ; レジスタの保存

    ; 食事の判定
    ld      a, (_value + VALUE_E)
    cp      #1
    jr      z, 17$
    cp      #3
    jr      z, 10$
    call    _SystemGetRandom
    cp      #(256 * 25 / 100 + 1)
    jr      nc, 17$
    jr      18$
10$:
    call    _SystemGetRandom
    cp      #(256 * 50 / 100)
    jr      c, 17$
    jr      18$
17$:
    ld      hl, #_Illness
    jr      19$
18$:
    ld      hl, #EventNext
;   jr      19$
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; インディアンが助けてくれる
;
EventHelpfulIndian:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; イベントの表示
    ld      hl, #eventHelpfulIndianString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 食糧の増加
    ld      hl, (_value + VALUE_F_L)
    ld      de, #14
    add     hl, de
    ld      (_value + VALUE_F_L), hl

    ; 処理の更新
    ld      hl, #EventNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
EventNext:
    
    ; レジスタの保存
    
    ; 処理の更新
    ld      hl, #_Mountain
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret
    
; 定数の定義
;

; テーブル
;
eventTable:

    .db     6, 11, 13, 15, 17, 22, 32, 35, 37, 42, 44, 54, 64, 69, 95, 100

; イベント別の処理
;
eventProc:

    .dw     EventBreakWagon
    .dw     EventInjureOxLeg
    .dw     EventBreakDaughterArm
    .dw     EventWanderOffOx
    .dw     EventLostSon
    .dw     EventUnsafeWater
    .dw     EventHeavyRain
    .dw     EventAttackBandit
    .dw     EventFireWagon
    .dw     EventHeavyFog
    .dw     EventBitPoisonSnake
    .dw     EventSwampWagon
    .dw     EventAttackWildAnimal
    .dw     EventHailStorm
    .dw     EventIllness
    .dw     EventHelpfulIndian

; 幌馬車が壊れる
;
eventBreakWagonString:

    .db     ____, __LF
    .db     _HHO, _HRO, _HHA, _KSN, _HSI, _Hya, _HKA, _KSN, ____, _HKO, _HWA, _HRE, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HHI, _HTU, _HSI, _KSN, _Hyu, _HHI, _H_N, _HWO, _HTU, _HKA, _Htu, _HTE, _HSI, _Hyu, _H_U, _HRI, _HWO, _HSU, _HRU, _HNO, _HNI, ____
    .db     _HSI, _KSN, _HKA, _H_N, _HKA, _KSN, _HKA, _HKA, _HRI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 牛が足を怪我する
;
eventInjureOxLegString:

    .db     ____, __LF
    .db     _H_U, _HSI, _HKA, _KSN, _H_A, _HSI, _HWO, ____, _HKE, _HKA, _KSN, _HSI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HTA, _HHI, _KSN, _HNO, _KHE, _KPS, _MNS, _KSU, _HHA, ____, _H_O, _HTI, _HSA, _KSN, _HRU, _HWO, _H_E, _HMA, _HSE, _H_N, _DOT
    .db     0x00

; 娘が腕を骨折する
;
eventBreakDaughterArmString:

    .db     ____, __LF
    .db     _HHU, _H_U, _H_N, _HNA, _HKO, _HTO, _HNI, ____, _H_A, _HNA, _HTA, _HNO, _HMU, _HSU, _HME, _HKA, _KSN, _H_U, _HTE, _KSN, _HWO, _HKO, _Htu, _HSE, _HTU, _HSI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HHI, _HTU, _HSI, _KSN, _Hyu, _HHI, _H_N, _HKA, _HRA, _HTU, _HRI, _HHO, _H_U, _HTA, _H_I, _HWO, _HTU, _HKU, _HRU, _H_A, _H_I, _HTA, _KSN, ____
    .db     _HTA, _HHI, _KSN, _HWO, _HSU, _HSU, _HME, _HRU, _HKO, _HTO, _HHA, _HTE, _KSN, _HKI, _HMA, _HSE, _H_N, _HTE, _KSN, _HSI, _HTA, _DOT
    .db     0x00
    
; 牛が逸れる
;
eventWanderOffOxString:

    .db     ____, __LF
    .db     _H_U, _HSI, _HKA, _KSN, ____, _HHA, _HKU, _KSN, _HRE, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _H_U, _HSI, _HWO, _HSA, _HKA, _KSN, _HSU, _HNO, _HNI, ____, _HSI, _KSN, _HKA, _H_N, _HKA, _KSN, _HKA, _HKA, _HRI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 息子が迷子になる
;
eventLostSonString:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HNO, _HMU, _HSU, _HKO, _HKA, _KSN, ____, _HMA, _H_I, _HKO, _KSN, _HNI, _HNA, _HRI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HMU, _HSU, _HKO, _HWO, _HSA, _HKA, _KSN, _HSU, _HNO, _HNI, ____, _HHA, _H_N, _HNI, _HTI, _HKA, _HKA, _HRI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 水が足りない
;
eventUnsafeWaterString:

    .db     ____, __LF
    .db     _HMI, _HSU, _KSN, _HKA, _KSN, _HSU, _HKU, _HNA, _HKU, _HNA, _HRI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _H_I, _HSU, _KSN, _HMI, _HWO, _HSA, _HKA, _KSN, _HSU, _HNO, _HNI, ____, _HSI, _KSN, _HKA, _H_N, _HKA, _KSN, _HKA, _HKA, _HRI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 大雨が降る
;
eventHeavyRainString:

    .db     ____, __LF
    .db     _H_O, _H_O, _H_A, _HME, _HKA, _KSN, ____, _HHU, _Htu, _HTE, _HKI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _H_O, _HMO, _H_U, _HYO, _H_U, _HNI, _HSU, _HSU, _HME, _HSU, _KSN, ____, _HMO, _HTI, _HMO, _HNO, _HNO, _H_I, _HKU, _HTU, _HKA, _HMO, _H_U, _HSI, _HNA, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 山賊が襲ってくる
;
eventAttackBanditBangString:

    .db     ____, __LF
    .db     _HSA, _H_N, _HSO, _KSN, _HKU, _HKA, _KSN, ____, _H_O, _HSO, _Htu, _HTE, _HKI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

eventAttackBanditLostCashString:

    .db     _HTA, _KSN, _H_N, _HYA, _HKU, _HWO, _H_U, _HTI, _HTU, _HKU, _HSI, _HTE, _HSI, _HMA, _H_I, ____, _H_O, _HKA, _HNE, _HWO, _H_U, _HHA, _KSN, _HWA, _HRE, _HMA, _HSI, _HTA, _DOT
    .db     0x00

eventAttackBanditLostOxenString:

    .db     _H_A, _HNA, _HTA, _HHA, _H_A, _HSI, _HWO, _H_U, _HTA, _HRE, ____, _H_U, _HSI, _HMO, ___1, _HTO, _H_U, _H_U, _HHA, _KSN, _HWA, _HRE, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HHA, _HYA, _HKU, _H_I, _HSI, _Hya, _HNI, _HMI, _HTE, _HMO, _HRA, _Htu, _HTA, _HHO, _H_U, _HKA, _KSN, ____, _HYO, _H_I, _HTE, _KSN, _HSI, _Hyo, _H_U, _DOT
    .db     0x00

eventAttackBanditSuccessString:

    .db     _HYA, _HRI, _HMA, _HSI, _HTA, _EXC, __LF
    .db     _KTO, _KSN, _Ktu, _KSI, _KSN, _KSI, _KTE, _K_i, _HNO, _HSO, _HTO, _HTE, _KSN, _HHA, ____, _H_I, _HTI, _HHA, _KSN, _H_N, _HNO, _HHA, _HYA, _H_U, _HTI, _HTE, _KSN, _HSU, _DOT
    .db     0x00

; 幌馬車で小火が起こる
;
eventFireWagonString:

    .db     ____, __LF
    .db     _HHO, _HRO, _HHA, _KSN, _HSI, _Hya, _HTE, _KSN, ____, _KHO, _KSN, _KYA, _HKA, _KSN, _H_O, _HKO, _HRI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HWO, _HHA, _HSI, _KSN, _HME, _H_I, _HKU, _HTU, _HKA, _HNO, _HMO, _HTI, _HMO, _HNO, _HNO, _HKA, _KSN, ____
    .db     _HYA, _HKE, _HTE, _HSI, _HMA, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 濃霧で道に迷う
;
eventHeavyFogString:

    .db     ____, __LF
    .db     _HNO, _H_U, _HMU, _HTE, _KSN, ____, _HMI, _HTI, _HNI, _HMA, _HYO, _H_I, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HYO, _HTE, _H_I, _HTO, _KSN, _H_O, _HRI, _HNI, _HHA, ____, _HSU, _HSU, _HME, _HMA, _HSE, _H_N, _HTE, _KSN, _HSI, _HTA, _DOT
    .db     0x00

; 毒蛇に噛まれる
;
eventBitPoisonSnakeBitString:

    .db     ____, __LF
    .db     _HTO, _KSN, _HKU, _HHE, _HHI, _KSN, _HNI, ____, _HKA, _HMA, _HRE, _HMA, _HSI, _HTA, _DOT
    .db     0x00

eventBitPoisonSnakeDieString:

    .db     _HKU, _HSU, _HRI, _HKA, _KSN, _HTA, _HRI, _HSU, _KSN, ____, _HTO, _KSN, _HKU, _HKA, _KSN, _HMA, _HWA, _Htu, _HTE, _HSI, _HNI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 川の浅瀬にはまる
;
eventSwampWagonString:

    .db     ____, __LF
    .db     _HHO, _HRO, _HHA, _KSN, _HSI, _Hya, _HKA, _KSN, ____, _HKA, _HWA, _HNO, _H_A, _HSA, _HSE, _HNI, _HHA, _HMA, _HRI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HYA, _H_I, _HRU, _H_I, _HKA, _KSN, ____, _HNA, _HKA, _KSN, _HSA, _HRE, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 野生の動物に襲われる
;
eventAttackWildAnimalBangString:

    .db     ____, __LF
    .db     _HKE, _HMO, _HNO, _HTA, _HTI, _HNI, ____, _H_O, _HSO, _HWA, _HRE, _HMA, _HSI, _HTA, _DOT
    .db     0x00

eventAttackWildAnimalDieString:

    .db     _H_A, _HNA, _HTA, _HHA, _HTA, _KSN, _H_N, _HYA, _HKU, _HWO, ____, _H_U, _HTI, _HTU, _HKU, _HSI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _H_O, _H_O, _HKA, _HMI, _HNI, _H_O, _HSO, _HWA, _HRE, ____, _H_A, _HNA, _HTA, _HHA, _HSI, _HNI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

eventAttackWildAnimalNiceString:

    .db     _HMI, _HKO, _KSN, _HTO, _HNA, _HSI, _Hya, _HKE, _KSN, _HKI, _HNO, ____, _H_U, _HTE, _KSN, _HMA, _H_E, _HTE, _KSN, _HSU, _DOT, __LF
    .db     _HKE, _HMO, _HNO, _HTA, _HTI, _HHA, ____, _HNI, _HKE, _KSN, _HTE, _HYU, _HKI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

eventAttackWildAnimalSlowString:

    .db     _HNA, _H_N, _HTO, _HKA, _H_O, _H_I, _HHA, _HRA, _H_I, _HMA, _HSI, _HTA, _HKA, _KSN, ____
    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HYA, _H_I, _HRU, _H_I, _HWO, _H_U, _HHA, _KSN, _HWA, _HRE, _HTE, _HSI, _HMA, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 寒波に見舞われる
;
eventColdWeatherEnoughClothString:

    .db     ____, __LF
    .db     _HKI, _HHI, _KSN, _HSI, _H_I, _HSA, _HMU, _HSA, _HKA, _KSN, _H_O, _HSI, _HYO, _HSE, _HTE, _HKI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HSA, _HMU, _HSA, _HNI, _HTA, _H_E, _HRU, _HTA, _KSN, _HKE, _HNO, _H_I, _HRU, _H_I, _HHA, ____
    .db     _HMO, _HTI, _H_A, _HWA, _HSE, _HTE, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     0x00

eventColdWeatherNotEnoughClothString:

    .db     ____, __LF
    .db     _HKI, _HHI, _KSN, _HSI, _H_I, _HSA, _HMU, _HSA, _HKA, _KSN, _H_O, _HSI, _HYO, _HSE, _HTE, _HKI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HSA, _HMU, _HSA, _HNI, _HTA, _H_E, _HRU, _HTA, _KSN, _HKE, _HNO, _H_I, _HRU, _H_I, _HHA, ____
    .db     _HMO, _HTI, _H_A, _HWA, _HSE, _HTE, _H_I, _HMA, _HSE, _H_N, _DOT
    .db     0x00

; 雹嵐に見舞われる
;
eventHailStromString:

    .db     ____, __LF
    .db     _HHA, _HKE, _KSN, _HSI, _H_I, _HKO, _H_U, _HHI, _Hyo, _H_U, _HNI, ____, _HMI, _HMA, _HWA, _HRE, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _H_I, _HKU, _HTU, _HKA, _HNO, _HMO, _HTI, _HMO, _HNO, _HKA, _KSN, ____, _HTU, _HKA, _H_I, _HMO, _HNO, _HNI, _HNA, _HRA, _HNA, _HKU, _HNA, _HRI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; インディアンが助けてくれる
;
eventHelpfulIndianString:

    .db     ____, __LF
    .db     _K_I, _K_N, _KTE, _KSN, _K_i, _K_A, _K_N, _HKA, _KSN, _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HKA, _KSN, _HTO, _HRE, _HRU, _HHA, _KSN, _HSI, _Hyo, _HWO, ____
    .db     _H_O, _HSI, _H_E, _HTE, _HKU, _HRE, _HMA, _HSI, _HTA, _DOT
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

