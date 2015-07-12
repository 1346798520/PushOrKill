int MGround = 520, PGround = 520;
Person p;
Box box,box2;
Monster mst;
int w = 60, h = 60;
final int initBX = 600;
final int initBY = 520 - h / 2;
boolean onBox = false, MonBox = false;
final float secondsDead = 2.;
float lastDead = -3.;
boolean win = false;

void setup() {
  size(1000,600);
  p = new Person(100,PGround,0,0); 
  box = new Box(initBX,initBY,w,h);
//  box2 = new Box(900, initBY, 0, h);
  mst = new Monster(700,MGround,4,0);
  line(0,520,1000,520);
  frameRate(30);
}

void draw() {
    if(p.lives >= 0 && !win) {
        background(255);
        apple();
        line(0,520,1000,520);
        p.Pmove();
        if(mst.xspeed != 0)mst.Mmove(); 
        p.gravity();
        if(mst.xspeed != 0)mst.gravity();  
        p.display();
        mst.drive();
        mst.display();
        box.rectbox();
 //       box2.rectbox();
        if(abs(p.xpos +20 -930)<=13.5 && abs(p.ypos - 25 -400) <= 11) {win = true;}
    }
    if(win) {
        fill(0,0,0);
        textSize(26);
        text("You WIN!",200,300);
    }
}

boolean inBox(float x1, float x2) {
    return (x1 <= box.x + 1 / 2. * w) && (x2 >= box.x - 1 / 2. * w);
}

boolean isRight(float xpos) {
    return xpos >= box.x + w / 2;
}

class Person {
    int d = 0;
    int lives = 3;
    float xpos;
    float ypos;
    float xspeed;
    float yspeed;
    boolean jumping = false;
    final float secondsInJump = 1;
    float secondsRemainingInJump;
    float yspeedup = 3;
    final float heightOfJump = 6;
    Person(float tempXpos, float tempYpos, float tempXspeed, float tempYspeed) { 
        xpos = tempXpos;
        ypos = tempYpos;
        xspeed = tempXspeed;
        yspeed = tempYspeed;
    }
    void display() {
        noFill();
        stroke(0);
        ellipse(xpos + 20, ypos - 50, 20, 20);
        line(xpos + 20, ypos - 40, xpos + 20, ypos - 20);
        line(xpos, ypos - 30, xpos + 40, ypos - 30);
        line(xpos + 20, ypos - 20, xpos + 10, ypos);
        line(xpos + 20, ypos - 20, xpos + 30, ypos);        
    }
    void drive(float xOffset) {
        xpos += xOffset;
    }
    void jump(float yOffset) {
        if (jumping) return;
        jumping = true;
        secondsRemainingInJump = secondsInJump;
    }
    void Pmove() {
        if (keyPressed) {
            if (key == 'd') drive(5);
            else if (key == 'w') jump(5);
            else if (key == 'a') drive(-5);    
        }
        if(p.xpos + 40 >= mst.xpos - 17 && p.xpos < mst.xpos + 17 && (int)p.ypos == (int)mst.ypos && mst.xspeed != 0) {p.ypos = PGround;box.boxkill();}
        if(p.xpos <= mst.xpos + 17 && p.xpos > mst.xpos - 17 && (int)p.ypos == (int)mst.ypos && mst.xspeed != 0) {p.ypos = PGround;box.boxkill();}
        if (!onBox) {
            if (inBox(p.xpos + 10, p.xpos + 30) && p.ypos <= PGround - h) {
                PGround -= h;
                onBox = true;
            } 
            else if (inBox(p.xpos, p.xpos + 40)) {
                 if (isRight(p.xpos + 10) && ypos >= PGround - h)
                     box.pushbox();
                 else
                     box.boxkill();
            }
        } 
        else {
            if (!inBox(p.xpos + 10, p.xpos + 30)) {
                secondsRemainingInJump = secondsInJump / 2.;
                jumping = true;
                PGround += h;
                onBox = false;
            }
        }
    }
    void gravity() {
        if (jumping) {
            if(secondsRemainingInJump == secondsInJump) mst.jumping = true;
            boolean goingUp = (secondsInJump / 2) < secondsRemainingInJump;
            ypos -= heightOfJump / (secondsInJump / 2) * (goingUp ? 1 : -1);
            secondsRemainingInJump -= (1 / 30.);
            if (secondsRemainingInJump == 0 || ypos >= PGround) {
                jumping = false;
                secondsRemainingInJump = secondsInJump;
            }
        }
    }
}

class Monster {
    float xpos; 
    float ypos;
    float xspeed;
    float yspeed;
    boolean jumping = false;
    final float secondsInJump = 1;
    float secondsRemainingInJump;
    float yspeedup = 3;
    final float heightOfJump = 6;
    Monster(float tempXpos, float tempYpos, float tempXspeed, float tempYspeed) {
        xpos = tempXpos;
        ypos = tempYpos;
        xspeed = tempXspeed;
        yspeed = tempYspeed;
    }
    void display() {
        //print(ypos,"\n");
        ellipse(xpos, ypos - 20, 40, 40);
        line(xpos - 10, ypos - 30, xpos + 10, ypos - 20);
        line(xpos - 10, ypos - 20, xpos + 10, ypos - 30);
        for(int i = -8; i <= 4; i += 4) {
            line(xpos + i, ypos - 12, xpos + i + 2, ypos - 8);
            line(xpos + i + 2, ypos - 8, xpos + i + 4, ypos - 12);
        }
    }
    void drive() {
        xpos += xspeed;
        if(xpos <= 20) xspeed = -xspeed;
        if(xpos >= 980) xspeed = -xspeed;
    }
    
    void Mmove() {
        if (!MonBox) {
            if (inBox(mst.xpos - 20, mst.xpos + 20) && mst.ypos <= MGround - h) {
                MGround -= h;
                MonBox = true;
            } 
            else if (inBox(xpos - 20, xpos + 20)) {
                 if (isRight(xpos) && ypos >= MGround - h)
                     xspeed = -xspeed;
                 else
                    xspeed = 0;
            }      
        } 
        else {
            if (!inBox(mst.xpos - 20, mst.xpos + 20)) {
                mst.secondsRemainingInJump = mst.secondsInJump / 2.;
                jumping = true;
                MGround += h;
                MonBox = false;
            }
        }
    }
    void gravity() {
         if (jumping) {
            boolean goingUp = (secondsInJump / 2) < secondsRemainingInJump;
            ypos -= heightOfJump / (secondsInJump / 2) * (goingUp ? 1 : -1);
            secondsRemainingInJump -= (1 / 30.);
            if (secondsRemainingInJump == 0 || ypos >= MGround) {
                jumping = false;
                secondsRemainingInJump = secondsInJump;
            }
        }
    }  
}

class Box {
    float x;
    float y;
    int w;
    int h;
    boolean IsPushed = false;
    Box(int centerx, int centery, int width, int height) {
        x = centerx;
        y = centery;
        w = width;
        h = height;
    }
    void rectbox() {
        stroke(0);
        fill(255);
        rectMode(CENTER);
        rect(x, y, w, h);
        for(int i = 0; i <= h - 5; i += 5) {
            triangle(x - w/2, y + h/2 - i, x - w/2 - 5, y + h/2 - i - 2.5, x - w/2, y + h/2 - i - 5);
        }
        if (lastDead + secondsDead > millis() / 1000.) {
            showDeadMsg();
        }
    }
    void pushbox() {
            x = p.xpos - w / 2;
            if (x <= w / 2) {
                p.xpos = w;
                x = w / 2;
            }
    }
    void boxkill() {
        if (p.ypos == PGround) {
            p.xpos = 500;
            p.lives--;
            x = initBX;
            y = initBY;
            PGround = 520;
            MGround = 520;
            p.xpos = 500;
            p.ypos = PGround;
            mst.xpos = 700;
            mst.ypos = 520;
            mst.xspeed = 4;
            lastDead = millis() / 1000.;
        }
    }
    void showDeadMsg() {
        fill(0);
        textSize(26);
        text("You die!\nLife", 200, 300);//bu zhi dao zen me da yin p.lives
    }
}

void apple() {
    fill(255,0,0);
    ellipse(930,420,27,22);
    noFill();
    curve(913,417,925,417,937,417,930,402);
    curve(927,429,932,417,942,411,898,430);
}

/*
    float ease (x, t, b, c, d) {
        return c*((t=t/d-1)*t*t + 1) + b;
    }
*/
