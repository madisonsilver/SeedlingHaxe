package net.flashpunk.utils;


/**
	 * Contains static key constants to be used by Input.
	 */
class Key
{
    public static var ANY : Int = -1;
    
    public static inline var LEFT : Int = 37;
    public static inline var UP : Int = 38;
    public static inline var RIGHT : Int = 39;
    public static inline var DOWN : Int = 40;
    
    public static inline var ENTER : Int = 13;
    public static inline var CONTROL : Int = 17;
    public static inline var SPACE : Int = 32;
    public static inline var SHIFT : Int = 16;
    public static inline var BACKSPACE : Int = 8;
    public static inline var CAPS_LOCK : Int = 20;
    public static inline var DELETE : Int = 46;
    public static inline var END : Int = 35;
    public static inline var ESCAPE : Int = 27;
    public static inline var HOME : Int = 36;
    public static inline var INSERT : Int = 45;
    public static inline var TAB : Int = 9;
    public static inline var PAGE_DOWN : Int = 34;
    public static inline var PAGE_UP : Int = 33;
    
    public static inline var A : Int = 65;
    public static inline var B : Int = 66;
    public static inline var C : Int = 67;
    public static inline var D : Int = 68;
    public static inline var E : Int = 69;
    public static inline var F : Int = 70;
    public static inline var G : Int = 71;
    public static inline var H : Int = 72;
    public static inline var I : Int = 73;
    public static inline var J : Int = 74;
    public static inline var K : Int = 75;
    public static inline var L : Int = 76;
    public static inline var M : Int = 77;
    public static inline var N : Int = 78;
    public static inline var O : Int = 79;
    public static inline var P : Int = 80;
    public static inline var Q : Int = 81;
    public static inline var R : Int = 82;
    public static inline var S : Int = 83;
    public static inline var T : Int = 84;
    public static inline var U : Int = 85;
    public static inline var V : Int = 86;
    public static inline var W : Int = 87;
    public static inline var X : Int = 88;
    public static inline var Y : Int = 89;
    public static inline var Z : Int = 90;
    
    public static inline var F1 : Int = 112;
    public static inline var F2 : Int = 113;
    public static inline var F3 : Int = 114;
    public static inline var F4 : Int = 115;
    public static inline var F5 : Int = 116;
    public static inline var F6 : Int = 117;
    public static inline var F7 : Int = 118;
    public static inline var F8 : Int = 119;
    public static inline var F9 : Int = 120;
    public static inline var F10 : Int = 121;
    public static inline var F11 : Int = 122;
    public static inline var F12 : Int = 123;
    public static inline var F13 : Int = 124;
    public static inline var F14 : Int = 125;
    public static inline var F15 : Int = 126;
    
    public static inline var DIGIT_0 : Int = 48;
    public static inline var DIGIT_1 : Int = 49;
    public static inline var DIGIT_2 : Int = 50;
    public static inline var DIGIT_3 : Int = 51;
    public static inline var DIGIT_4 : Int = 52;
    public static inline var DIGIT_5 : Int = 53;
    public static inline var DIGIT_6 : Int = 54;
    public static inline var DIGIT_7 : Int = 55;
    public static inline var DIGIT_8 : Int = 56;
    public static inline var DIGIT_9 : Int = 57;
    
    public static inline var NUMPAD_0 : Int = 96;
    public static inline var NUMPAD_1 : Int = 97;
    public static inline var NUMPAD_2 : Int = 98;
    public static inline var NUMPAD_3 : Int = 99;
    public static inline var NUMPAD_4 : Int = 100;
    public static inline var NUMPAD_5 : Int = 101;
    public static inline var NUMPAD_6 : Int = 102;
    public static inline var NUMPAD_7 : Int = 103;
    public static inline var NUMPAD_8 : Int = 104;
    public static inline var NUMPAD_9 : Int = 105;
    public static inline var NUMPAD_ADD : Int = 107;
    public static inline var NUMPAD_DECIMAL : Int = 110;
    public static inline var NUMPAD_DIVIDE : Int = 111;
    public static inline var NUMPAD_ENTER : Int = 108;
    public static inline var NUMPAD_MULTIPLY : Int = 106;
    public static inline var NUMPAD_SUBTRACT : Int = 109;
    
    /**
		 * Returns the name of the key.
		 * @param	char		The key to name.
		 * @return	The name.
		 */
    public static function name(char : Int) : String
    {
        if (char >= A && char <= Z)
        {
            return String.fromCharCode(char);
        }
        if (char >= F1 && char <= F15)
        {
            return "F" + Std.string(char - 111);
        }
        if (char >= 96 && char <= 105)
        {
            return "NUMPAD " + Std.string(char - 96);
        }
        switch (char)
        {
            case LEFT:
                return "LEFT";
            
            case UP:
                return "UP";
            
            case RIGHT:
                return "RIGHT";
            
            case DOWN:
                return "DOWN";
            
            case ENTER:
                return "ENTER";
            
            case CONTROL:
                return "CONTROL";
            
            case SPACE:
                return "SPACE";
            
            case SHIFT:
                return "SHIFT";
            
            case BACKSPACE:
                return "BACKSPACE";
            
            case CAPS_LOCK:
                return "CAPS LOCK";
            
            case DELETE:
                return "DELETE";
            
            case END:
                return "END";
            
            case ESCAPE:
                return "ESCAPE";
            
            case HOME:
                return "HOME";
            
            case INSERT:
                return "INSERT";
            
            case TAB:
                return "TAB";
            
            case PAGE_DOWN:
                return "PAGE DOWN";
            
            case PAGE_UP:
                return "PAGE UP";
            
            case NUMPAD_ADD:
                return "NUMPAD ADD";
            
            case NUMPAD_DECIMAL:
                return "NUMPAD DECIMAL";
            
            case NUMPAD_DIVIDE:
                return "NUMPAD DIVIDE";
            
            case NUMPAD_ENTER:
                return "NUMPAD ENTER";
            
            case NUMPAD_MULTIPLY:
                return "NUMPAD MULTIPLY";
            
            case NUMPAD_SUBTRACT:
                return "NUMPAD SUBTRACT";
            default:
                return String.fromCharCode(char);
        }
        return String.fromCharCode(char);
    }

    public function new()
    {
    }
}
