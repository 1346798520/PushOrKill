int ground = 520, ph = 30;
Person p;
Box box;
int w=60;
int x=600;
boolean onBox = false;
void setup() {
  size(1000,600);
  p = new Person(500,ground,0,0); 
  box = new Box(x,490,w,w);
  line(0,520,1000,520);
  frameRate(30);
}

void draw() {
    background(255);
    line(0,520,1000,520);
    if (keyPressed) {
        if (key == 'd') p.drive(5);
        else if (key == 's') p.jump(5);
        else if (key == 'a') p.drive(-5);
        
    }
    print(p.xpos);
    print(" ", x - 1 / 2. * w, x + 1 / 2. * w, "\n");
    if (!onBox) {
        if (onBoxNow() && p.ypos <= ground - w) {
            ground -= 60;
            onBox = true;
        } else {
            if (onBoxNow()) {
                
            }
        }
    } else {
        if (!onBoxNow()) {
            p.secondsRemainingInJump = p.secondsInJump / 2.;
            p.jumping = true;
            ground += 60;
            onBox = false;
        }
    }
    box.rectbox();
    p.gravity();
    p.display();
}

boolean onBoxNow() {
    //print((p.xpos + 10 <= x + 1 / 2. * w) && (p.xpos + 30 >= x - 1 / 2. * w), " \n");
    return (p.xpos + 10 <= x + 1 / 2. * w) && (p.xpos + 30 >= x - 1 / 2. * w);
}

class Person {
    int d = 0;
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
    void changeSpeed(float xSpeed, float ySpeed) {
        if (xSpeed >= 0) xspeed = xSpeed;
        if (ySpeed >= 0) yspeed = ySpeed;
    }
    /*
    float ease (x, t, b, c, d) {
        return c*((t=t/d-1)*t*t + 1) + b;
    }
*/
    void gravity() {
        if (jumping) {
            boolean goingUp = (secondsInJump / 2) < secondsRemainingInJump;
            ypos -= heightOfJump / (secondsInJump / 2) * (goingUp ? 1 : -1);
            secondsRemainingInJump -= (1 / 30.);
            if (secondsRemainingInJump == 0 || ypos >= ground) {
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
    }
    void pushbox() {
        if ((p.xpos <= x + w / 2) && (p.ypos == ground)) {
            x = p.xpos - w / 2;
            if (x <= w / 2) {
                p.xpos = w;
            }
        }
    }
//    void boxkill() {
//        if ((xpos + 30 == x - 1 / 2 * w) && (ypos == ground)) {
//            xpos = 500;
//            textSize(26);
//            text("You die!", 200, 300);
//            life = life - 1;
//        }
//        if (xe + 20 == x - 1 / 2 * w) { 
//            ye = ye - 1000;
//        }
//    }
}