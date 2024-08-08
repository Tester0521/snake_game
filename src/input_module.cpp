extern "C" {
    #include <lua.h>
    #include <lauxlib.h>
    #include <lualib.h>
}

#include <iostream>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>

int enable_raw_mode(lua_State* L) {
    termios term;
    tcgetattr(STDIN_FILENO, &term);
    term.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &term);

    int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK);

    return 0;
}

int disable_raw_mode(lua_State* L) {
    termios term;
    tcgetattr(STDIN_FILENO, &term);
    term.c_lflag |= (ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &term);

    int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    fcntl(STDIN_FILENO, F_SETFL, flags & ~O_NONBLOCK);

    return 0;
}

int read_input(lua_State* L) {
    char buf = 0;
    int n = read(STDIN_FILENO, &buf, 1);
    
    if (n > 0) {
        lua_pushlstring(L, &buf, 1);
    } else {
        lua_pushnil(L); 
    }
    
    return 1; 
}

extern "C" int luaopen_input_module(lua_State* L) {
    static const luaL_Reg functions[] = {
        {"enable_raw_mode", enable_raw_mode},
        {"disable_raw_mode", disable_raw_mode},
        {"read_input", read_input},
        {NULL, NULL}
    };

    luaL_newlib(L, functions);
    return 1;
}
