class Chess {
  //peices
  String wk = "♔";
  String wq = "♕";
  String wr = "♖";
  String wb = "♗";
  String wkn = "♘";
  String wp = "♙";
  String bk = "♚";
  String bq = "♛";
  String br = "♜";
  String bb = "♝";
  String bkn = "♞";
  String bp = "♟";
  int[] selected = {-2, -2};
  int[] pawn_data = {-2, -2};
  String[][] redomemory = new String[8][8];
  //true is white
  boolean player = true;
  int promote = 0;
  boolean hasredomove = false;
  int b = 0;
  boolean castling = false;
  boolean cheat = false;


  String[][] rows = new String[8][8];

  //board drawing
  void drawboard() {
    noStroke();
    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        fill(colour);
        square(x*50, y*50, 50);
        swapColour();
      }
      swapColour();
    }
  }

  void swapColour () {
    if (colour == 100) {
      colour = 200;
    } else {
      colour = 100;
    }
  }

  //starting peices
  void reset() {
    String setup[][] = {{br, bkn, bb, bq, bk, bb, bkn, br}, {bp, bp, bp, bp, bp, bp, bp, bp}, {wp, wp, wp, wp, wp, wp, wp, wp}, {wr, wkn, wb, wq, wk, wb, wkn, wr}};
    rows[0] = setup[0];
    rows[1] = setup[1];
    rows[6] = setup[2];
    rows[7] = setup[3];
  }

  void display_peices() {
    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        if (rows[x][y] == null) continue;
        fill(0);
        text(rows[x][y], y*50, x*50+45);
      }
    }
  }

  void selected_outline() {
    stroke(255, 0, 0);
    strokeWeight(5);
    noFill();
    square(selected[1]*50, selected[0]*50, 50);
  }

  //selecting

  void select(int x, int y) {
    try {
      if (player == true) {
        if (rows[x][y].contains(wk)||rows[x][y].contains(wq)||rows[x][y].contains(wr)||rows[x][y].contains(wkn)||rows[x][y].contains(wb)||rows[x][y].contains(wp)) {
          selected[0] = x;
          selected[1] = y;
        } else if (rows[x][y].contains(bk)||rows[x][y].contains(bq)||rows[x][y].contains(br)||rows[x][y].contains(bkn)||rows[x][y].contains(bb)||rows[x][y].contains(bp)) {
          if (selected[0] == -2 && selected[1] == -2) {
          } else {
            move(x, y);
          }
        }
      } else {
        if (rows[x][y].contains(bk)||rows[x][y].contains(bq)||rows[x][y].contains(br)||rows[x][y].contains(bkn)||rows[x][y].contains(bb)||rows[x][y].contains(bp)) {
          selected[0] = x;
          selected[1] = y;
        } else if (rows[x][y].contains(wk)||rows[x][y].contains(wq)||rows[x][y].contains(wr)||rows[x][y].contains(wkn)||rows[x][y].contains(wb)||rows[x][y].contains(wp)) {
          if (selected[0] == -2 && selected[1] == -2) {
          } else {
            move(x, y);
          }
        }
      }
    } 
    catch (NullPointerException e) {
      if (selected[0] != -2 && selected[1] != -2) {
        move(x, y);
      }
    }
    promote(x, y);
  }

  void move(int x, int y) {
    if (valid_move(x, y) || cheat) {
      hasredomove = false;
      save_redo();
      rows[x][y] = rows[selected[0]][selected[1]];
      player = !player;
      if (castle(x, y) == true) { 
        player = !player;
        castling = true;
      }
      rows[selected[0]][selected[1]] = null;
      empty_array(selected);
    }
  }

  void promote(int x, int y) {
    if (rows[7][y]==bp) {
      promote = 1;
      pawn_data[0] = x;
      pawn_data[1] = y;
    } else if (rows[0][y]==wp) {
      promote = 2;
      pawn_data[0] = x;
      pawn_data[1] = y;
    }
  }

  void promote_display_black() {
    stroke(0);
    strokeWeight(1);
    fill(255);
    rect(100, 175, 200, 50);
    fill(0);
    text(one.bq+one.bb+one.bkn+one.br, 100, 220);
  }

  void promote_display_white() {
    stroke(0);
    strokeWeight(1);
    fill(255);
    rect(100, 175, 200, 50);
    fill(0);
    text(one.wq+one.wb+one.wkn+one.wr, 100, 220);
  }

  boolean castle(int x, int y) {
    if ((selected[0] == 7 || selected[0] == 0) && (selected[1] == 4) && (selected[1]-2 == y || selected[1]+2 == y) && (rows[x][y].contains(wk) || (rows[x][y].contains(bk)))) {
      return true;
    } else {
      return false;
    }
  }

  void redo() {
    if (!hasredomove) {
      hasredomove = true;
      player = !player;
      arrayCopy(redomemory[0], rows[0]);
      arrayCopy(redomemory[1], rows[1]);
      arrayCopy(redomemory[2], rows[2]);
      arrayCopy(redomemory[3], rows[3]);
      arrayCopy(redomemory[4], rows[4]);
      arrayCopy(redomemory[5], rows[5]);
      arrayCopy(redomemory[6], rows[6]);
      arrayCopy(redomemory[7], rows[7]);
    }
  }

  void save_redo() {
    arrayCopy(rows[0], redomemory[0]);
    arrayCopy(rows[1], redomemory[1]);
    arrayCopy(rows[2], redomemory[2]);
    arrayCopy(rows[3], redomemory[3]);
    arrayCopy(rows[4], redomemory[4]);
    arrayCopy(rows[5], redomemory[5]);
    arrayCopy(rows[6], redomemory[6]);
    arrayCopy(rows[7], redomemory[7]);
  }


  boolean valid_move(int x, int y) {
    try {
      if (castling && (rows[selected[0]][selected[1]].contains(wr) || rows[selected[0]][selected[1]].contains(br))) {
        castling = false;
        return true;
      }
      //white pawn moves
      if ((selected[0] == 6 || selected[0] == 1) && (selected[1] == y) && (selected[0]-2 == x) && (rows[selected[0]-1][selected[1]] == null) && (rows[selected[0]-2][selected[1]] == null) && (rows[selected[0]][selected[1]].contains(wp))) {
        return true;
      } else if ((selected[1] == y) && (selected[0]-1 == x) && (rows[selected[0]-1][selected[1]] == null) &&(rows[selected[0]][selected[1]].contains(wp))) {
        return true;
      } else if (((selected[1]+1 == y) || (selected[1]-1 == y)) && (selected[0]-1 == x) && (rows[selected[0]][selected[1]].contains(wp)) && (rows[x][y].contains(bk)||rows[x][y].contains(bq)||rows[x][y].contains(br)||rows[x][y].contains(bkn)||rows[x][y].contains(bb)||rows[x][y].contains(bp))) {
        return true;
      } 
      //black pawn moves
      else if ((selected[0] == 6 || selected[0] == 1) && (selected[1] == y) && (selected[0]+2 == x) && (rows[selected[0]+1][selected[1]] == null) && (rows[selected[0]+2][selected[1]] == null) &&(rows[selected[0]][selected[1]].contains(bp))) {
        return true;
      } else if ((selected[1] == y) && (selected[0]+1 == x) && (rows[selected[0]+1][selected[1]] == null) && (rows[selected[0]][selected[1]].contains(bp))) {
        return true;
      } else if (((selected[1]+1 == y) || (selected[1]-1 == y)) && (selected[0]+1 == x) && (rows[selected[0]][selected[1]].contains(bp)) && (rows[x][y].contains(wk)||rows[x][y].contains(wq)||rows[x][y].contains(wr)||rows[x][y].contains(wkn)||rows[x][y].contains(wb)||rows[x][y].contains(wp))) {
        return true;
      } 
      //king
      else if ((selected[0]+1 == x || selected[0]-1 == x || selected[0] == x) && (selected[1]+1 == y || selected[1]-1 == y || selected[1] == y) && (rows[selected[0]][selected[1]].contains(wk) || rows[selected[0]][selected[1]].contains(bk))) {
        return true;
      } else if ((selected[0] == 7 || selected[0] == 0) && (selected[1] == 4) && (selected[1]-2 == y || selected[1]+2 == y) && (rows[selected[0]][selected[1]].contains(wk) || (rows[selected[0]][selected[1]].contains(bk)))) {
        return true;
      }
      //rook
      else if ((selected[0] == x || selected[1] == y) && (rows[selected[0]][selected[1]].contains(wr) || rows[selected[0]][selected[1]].contains(br))) {
        if (selected[0] < x && selected[1] == y) {
          for (int i = selected[0]+1; i < x; i = i+1) {
            if (rows[i][y] != null) {
              return false;
            }
          }
          return true;
        } else if (selected[0] > x && selected[1] == y) {
          for (int i = selected[0]-1; i > x; i = i-1) {
            if (rows[i][y] != null) {
              return false;
            }
          }
          return true;
        } else if (selected[1] < y && selected[0] == x) {
          for (int i = selected[1]+1; i < y; i = i+1) {
            if (rows[x][i] != null) {
              return false;
            }
          }
          return true;
        } else if (selected[1] > y && selected[0] == x) {
          for (int i = selected[1]-1; i > y; i = i-1) {
            if (rows[x][i] != null) {
              return false;
            }
          }
          return true;
        }
      }
      //bishop
      else if ((abs(selected[0]-x) == abs(selected[1]-y)) && (rows[selected[0]][selected[1]].contains(wb) || rows[selected[0]][selected[1]].contains(bb))) {
        b = selected[1]+1;
        if (selected[0] < x && selected[1] < y) {
          for (int a = selected[0]+1; a < x; a = a+1) {
            if (rows[a][b] != null) {
              return false;
            } else {
              b = b+1;
            }
          }
          return true;
        } else if (selected[0] < x && selected[1] > y) {
          b = selected[1]-1;
          for (int a = selected[0]+1; a < x; a = a+1) {
            if (rows[a][b] != null) {
              return false;
            } else {
              b = b-1;
            }
          }
          return true;
        } else if (selected[0] > x && selected[1] < y) {
          b = selected[1]+1;
          for (int a = selected[0]-1; a > x; a = a-1) {
            if (rows[a][b] != null) {
              return false;
            } else {
              b = b+1;
            }
          }
          return true;
        } else if (selected[0] > x && selected[1] > y) {
          b = selected[1]-1;
          for (int a = selected[0]-1; a > x; a = a-1) {
            if (rows[a][b] != null) {
              return false;
            } else {
              b = b-1;
            }
          }
          return true;
        }
      }
      //queen
      else if ((rows[selected[0]][selected[1]].contains(wq) || rows[selected[0]][selected[1]].contains(bq))) {
        if ((selected[0] == x || selected[1] == y)) {
          if (selected[0] < x && selected[1] == y) {
            for (int i = selected[0]+1; i < x; i = i+1) {
              if (rows[i][y] != null) {
                return false;
              }
            }
            return true;
          } else if (selected[0] > x && selected[1] == y) {
            for (int i = selected[0]-1; i > x; i = i-1) {
              if (rows[i][y] != null) {
                return false;
              }
            }
            return true;
          } else if (selected[1] < y && selected[0] == x) {
            for (int i = selected[1]+1; i < y; i = i+1) {
              if (rows[x][i] != null) {
                return false;
              }
            }
            return true;
          } else if (selected[1] > y && selected[0] == x) {
            for (int i = selected[1]-1; i > y; i = i-1) {
              if (rows[x][i] != null) {
                return false;
              }
            }
            return true;
          }
        } else if ((abs(selected[0]-x) == abs(selected[1]-y))) {
          b = selected[1]+1;
          if (selected[0] < x && selected[1] < y) {
            for (int a = selected[0]+1; a < x; a = a+1) {
              if (rows[a][b] != null) {
                return false;
              } else {
                b = b+1;
              }
            }
            return true;
          } else if (selected[0] < x && selected[1] > y) {
            b = selected[1]-1;
            for (int a = selected[0]+1; a < x; a = a+1) {
              if (rows[a][b] != null) {
                return false;
              } else {
                b = b-1;
              }
            }
            return true;
          } else if (selected[0] > x && selected[1] < y) {
            b = selected[1]+1;
            for (int a = selected[0]-1; a > x; a = a-1) {
              if (rows[a][b] != null) {
                return false;
              } else {
                b = b+1;
              }
            }
            return true;
          } else if (selected[0] > x && selected[1] > y) {
            b = selected[1]-1;
            for (int a = selected[0]-1; a > x; a = a-1) {
              if (rows[a][b] != null) {
                return false;
              } else {
                b = b-1;
              }
            }
            return true;
          }
        }
      } 
      //knight
      else if ((rows[selected[0]][selected[1]].contains(wkn) || rows[selected[0]][selected[1]].contains(bkn))) {
        if (selected[0]+2 == x && selected[1]+1 == y) {
          return true;
        } else if (selected[0]+2 == x && selected[1]-1 == y) {
          return true;
        } else if (selected[0]+1 == x && selected[1]-2 == y) {
          return true;
        } else if (selected[0]-1 == x && selected[1]-2 == y) {
          return true;
        } else if (selected[0]-2 == x && selected[1]+1 == y) {
          return true;
        } else if (selected[0]-2 == x && selected[1]-1 == y) {
          return true;
        } else if (selected[0]+1 == x && selected[1]+2 == y) {
          return true;
        } else if (selected[0]-1 == x && selected[1]+2 == y) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } 
    catch (NullPointerException e) {
      return false;
    }
    return false;
  }

  //em passent

  void select_to_promote() {
    if (promote == 1) {
      if (mouseY >= 175 && mouseY <= 225 && mouseX >= 100 && mouseX <= 150) {
        rows[pawn_data[0]][pawn_data[1]] = bq;
        promote = 0;
      }
      if (mouseY >= 175 && mouseY <= 225 && mouseX >= 150 && mouseX <= 200) {
        rows[pawn_data[0]][pawn_data[1]] = bb;
        promote = 0;
      }
      if (mouseY >= 175 && mouseY <= 225 && mouseX >= 200 && mouseX <= 250) {
        rows[pawn_data[0]][pawn_data[1]] = bkn;
        promote = 0;
      }
      if (mouseY >= 175 && mouseY <= 225 && mouseX >= 250 && mouseX <= 300) {
        rows[pawn_data[0]][pawn_data[1]] = br;
        promote = 0;
      }
    } else {
      if (mouseY >= 175 && mouseY <= 225 && mouseX >= 100 && mouseX <= 150) {
        rows[pawn_data[0]][pawn_data[1]] = wq;
        promote = 0;
      }
      if (mouseY >= 175 && mouseY <= 225 && mouseX >= 150 && mouseX <= 200) {
        rows[pawn_data[0]][pawn_data[1]] = wb;
        promote = 0;
      }
      if (mouseY >= 175 && mouseY <= 225 && mouseX >= 200 && mouseX <= 250) {
        rows[pawn_data[0]][pawn_data[1]] = wkn;
        promote = 0;
      }
      if (mouseY >= 175 && mouseY <= 225 && mouseX >= 250 && mouseX <= 300) {
        rows[pawn_data[0]][pawn_data[1]] = wr;
        promote = 0;
      }
    }
  }

  // void empty_rows() {
  //   redomemory = new String[8][8];
  // }

  void empty_array(int[] array) {
    array[0] = -2;
    array[1] = -2;
  }

  void select_peice() {
    //row1
    if (mouseY >= 0 && mouseY <= 50 && mouseX >= 0 && mouseX <= 50) {
      select(0, 0);
    }
    if (mouseY >= 0 && mouseY <= 50 && mouseX >= 50 && mouseX <= 100) {
      select(0, 1);
    }
    if (mouseY >= 0 && mouseY <= 50 && mouseX >= 100 && mouseX <= 150) {
      select(0, 2);
    }
    if (mouseY >= 0 && mouseY <= 50 && mouseX >= 150 && mouseX <= 200) {
      select(0, 3);
    }
    if (mouseY >= 0 && mouseY <= 50 && mouseX >= 200 && mouseX <= 250) {
      select(0, 4);
    }
    if (mouseY >= 0 && mouseY <= 50 && mouseX >= 250 && mouseX <= 300) {
      select(0, 5);
    }
    if (mouseY >= 0 && mouseY <= 50 && mouseX >= 300 && mouseX <= 350) {
      select(0, 6);
    }
    if (mouseY >= 0 && mouseY <= 50 && mouseX >= 350 && mouseX <= 400) {
      select(0, 7);
    }
    //row2
    if (mouseY >= 50 && mouseY <= 100 && mouseX >= 0 && mouseX <= 50) {
      select(1, 0);
    }
    if (mouseY >= 50 && mouseY <= 100 && mouseX >= 50 && mouseX <= 100) {
      select(1, 1);
    }
    if (mouseY >= 50 && mouseY <= 100 && mouseX >= 100 && mouseX <= 150) {
      select(1, 2);
    }
    if (mouseY >= 50 && mouseY <= 100 && mouseX >= 150 && mouseX <= 200) {
      select(1, 3);
    }
    if (mouseY >= 50 && mouseY <= 100 && mouseX >= 200 && mouseX <= 250) {
      select(1, 4);
    }
    if (mouseY >= 50 && mouseY <= 100 && mouseX >= 250 && mouseX <= 300) {
      select(1, 5);
    }
    if (mouseY >= 50 && mouseY <= 100 && mouseX >= 300 && mouseX <= 350) {
      select(1, 6);
    }
    if (mouseY >= 50 && mouseY <= 100 && mouseX >= 350 && mouseX <= 400) {
      select(1, 7);
    }
    //row3
    if (mouseY >= 100 && mouseY <= 150 && mouseX >= 0 && mouseX <= 50) {
      select(2, 0);
    }
    if (mouseY >= 100 && mouseY <= 150 && mouseX >= 50 && mouseX <= 100) {
      select(2, 1);
    }
    if (mouseY >= 100 && mouseY <= 150 && mouseX >= 100 && mouseX <= 150) {
      select(2, 2);
    }
    if (mouseY >= 100 && mouseY <= 150 && mouseX >= 150 && mouseX <= 200) {
      select(2, 3);
    }
    if (mouseY >= 100 && mouseY <= 150 && mouseX >= 200 && mouseX <= 250) {
      select(2, 4);
    }
    if (mouseY >= 100 && mouseY <= 150 && mouseX >= 250 && mouseX <= 300) {
      select(2, 5);
    }
    if (mouseY >= 100 && mouseY <= 150 && mouseX >= 300 && mouseX <= 350) {
      select(2, 6);
    }
    if (mouseY >= 100 && mouseY <= 150 && mouseX >= 350 && mouseX <= 400) {
      select(2, 7);
    }
    //row4
    if (mouseY >= 150 && mouseY <= 200 && mouseX >= 0 && mouseX <= 50) {
      select(3, 0);
    }
    if (mouseY >= 150 && mouseY <= 200 && mouseX >= 50 && mouseX <= 100) {
      select(3, 1);
    }
    if (mouseY >= 150 && mouseY <= 200 && mouseX >= 100 && mouseX <= 150) {
      select(3, 2);
    }
    if (mouseY >= 150 && mouseY <= 200 && mouseX >= 150 && mouseX <= 200) {
      select(3, 3);
    }
    if (mouseY >= 150 && mouseY <= 200 && mouseX >= 200 && mouseX <= 250) {
      select(3, 4);
    }
    if (mouseY >= 150 && mouseY <= 200 && mouseX >= 250 && mouseX <= 300) {
      select(3, 5);
    }
    if (mouseY >= 150 && mouseY <= 200 && mouseX >= 300 && mouseX <= 350) {
      select(3, 6);
    }
    if (mouseY >= 150 && mouseY <= 200 && mouseX >= 350 && mouseX <= 400) {
      select(3, 7);
    }
    //row5
    if (mouseY >= 200 && mouseY <= 250 && mouseX >= 0 && mouseX <= 50) {
      select(4, 0);
    }
    if (mouseY >= 200 && mouseY <= 250 && mouseX >= 50 && mouseX <= 100) {
      select(4, 1);
    }
    if (mouseY >= 200 && mouseY <= 250 && mouseX >= 100 && mouseX <= 150) {
      select(4, 2);
    }
    if (mouseY >= 200 && mouseY <= 250 && mouseX >= 150 && mouseX <= 200) {
      select(4, 3);
    }
    if (mouseY >= 200 && mouseY <= 250 && mouseX >= 200 && mouseX <= 250) {
      select(4, 4);
    }
    if (mouseY >= 200 && mouseY <= 250 && mouseX >= 250 && mouseX <= 300) {
      select(4, 5);
    }
    if (mouseY >= 200 && mouseY <= 250 && mouseX >= 300 && mouseX <= 350) {
      select(4, 6);
    }
    if (mouseY >= 200 && mouseY <= 250 && mouseX >= 350 && mouseX <= 400) {
      select(4, 7);
    }
    //row6
    if (mouseY >= 250 && mouseY <= 300 && mouseX >= 0 && mouseX <= 50) {
      select(5, 0);
    }
    if (mouseY >= 250 && mouseY <= 300 && mouseX >= 50 && mouseX <= 100) {
      select(5, 1);
    }
    if (mouseY >= 250 && mouseY <= 300 && mouseX >= 100 && mouseX <= 150) {
      select(5, 2);
    }
    if (mouseY >= 250 && mouseY <= 300 && mouseX >= 150 && mouseX <= 200) {
      select(5, 3);
    }
    if (mouseY >= 250 && mouseY <= 300 && mouseX >= 200 && mouseX <= 250) {
      select(5, 4);
    }
    if (mouseY >= 250 && mouseY <= 300 && mouseX >= 250 && mouseX <= 300) {
      select(5, 5);
    }
    if (mouseY >= 250 && mouseY <= 300 && mouseX >= 300 && mouseX <= 350) {
      select(5, 6);
    }
    if (mouseY >= 250 && mouseY <= 300 && mouseX >= 350 && mouseX <= 400) {
      select(5, 7);
    }
    //row7
    if (mouseY >= 300 && mouseY <= 350 && mouseX >= 0 && mouseX <= 50) {
      select(6, 0);
    }
    if (mouseY >= 300 && mouseY <= 350 && mouseX >= 50 && mouseX <= 100) {
      select(6, 1);
    }
    if (mouseY >= 300 && mouseY <= 350 && mouseX >= 100 && mouseX <= 150) {
      select(6, 2);
    }
    if (mouseY >= 300 && mouseY <= 350 && mouseX >= 150 && mouseX <= 200) {
      select(6, 3);
    }
    if (mouseY >= 300 && mouseY <= 350 && mouseX >= 200 && mouseX <= 250) {
      select(6, 4);
    }
    if (mouseY >= 300 && mouseY <= 350 && mouseX >= 250 && mouseX <= 300) {
      select(6, 5);
    }
    if (mouseY >= 300 && mouseY <= 350 && mouseX >= 300 && mouseX <= 350) {
      select(6, 6);
    }
    if (mouseY >= 300 && mouseY <= 350 && mouseX >= 350 && mouseX <= 400) {
      select(6, 7);
    }
    //row8
    if (mouseY >= 350 && mouseY <= 400 && mouseX >= 0 && mouseX <= 50) {
      select(7, 0);
    }
    if (mouseY >= 350 && mouseY <= 400 && mouseX >= 50 && mouseX <= 100) {
      select(7, 1);
    }
    if (mouseY >= 350 && mouseY <= 400 && mouseX >= 100 && mouseX <= 150) {
      select(7, 2);
    }
    if (mouseY >= 350 && mouseY <= 400 && mouseX >= 150 && mouseX <= 200) {
      select(7, 3);
    }
    if (mouseY >= 350 && mouseY <= 400 && mouseX >= 200 && mouseX <= 250) {
      select(7, 4);
    }
    if (mouseY >= 350 && mouseY <= 400 && mouseX >= 250 && mouseX <= 300) {
      select(7, 5);
    }
    if (mouseY >= 350 && mouseY <= 400 && mouseX >= 300 && mouseX <= 350) {
      select(7, 6);
    }
    if (mouseY >= 350 && mouseY <= 400 && mouseX >= 350 && mouseX <= 400) {
      select(7, 7);
    }
  }
}
