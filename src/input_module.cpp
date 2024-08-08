extern "C" {
    #include <lua.h>
    #include <lauxlib.h>
    #include <lualib.h>
}

#include <iostream>
#include <termios.h>
#include <unistd.h>

int enable_raw_mode(lua_State* L) {
    termios term;
    tcgetattr(STDIN_FILENO, &term);
    term.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &term);

    return 0;
}

int disable_raw_mode(lua_State* L) {
    termios term;
    tcgetattr(STDIN_FILENO, &term);
    term.c_lflag |= (ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &term);

    return 0;
}

int get_char(lua_State* L) {
    char s;

    std::cin >> s;

    lua_pushstring(L, &s);

    return 1;
}

extern "C" int luaopen_input_module(lua_State* L) {
    static const luaL_Reg functions[] = {
        {"enable_raw_mode", enable_raw_mode},
        {"disable_raw_mode", disable_raw_mode},
        {"get_char", get_char},
        {NULL, NULL}
    };

    luaL_newlib(L, functions);
    return 1;
}
