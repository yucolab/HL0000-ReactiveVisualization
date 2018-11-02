
 
import com.thomasdiewald.pixelflow.java.softbodydynamics.particle.DwParticle2D;
import com.thomasdiewald.pixelflow.java.softbodydynamics.particle.DwParticle;
import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.core.PShape;
 
static class CustomVerletParticle2D extends DwParticle2D{
  public CustomVerletParticle2D(int idx) {
    super(idx);
  }

  private final float[] rgb = new float[3];
   
  //protected final float[][] PALLETTE = {
  //  { 30,  60,  110},    
  //  { 50, 80, 120}, 
  //  { 130, 208, 255},
  //};
  
    protected final float[][] PALLETTE = {
    { 50,  80,  130},    
    { 100, 178, 255}, 
    { 255, 120, 50},
  };
  
  public boolean isOccupied;
  public float initialPosX;
  public float initialPosY;
  
  @Override
  public void updateShapeColor(){

    float vel  = getVelocity();
    float radn = 1.1f * rad / MAX_RAD;
    
    float val = vel/1;
    //getShading(val, rgb);
    
    //my own getShading
    if(val < 0.0) val = 0.0f; else if(val >= 1.0) val = 0.99999f;
    float lum_steps = val * (PALLETTE.length-1);
    
    int   idx2 = (int)(Math.floor(lum_steps));
    float fract = lum_steps - idx2;
    
    rgb[0] = PALLETTE[idx2][0] * (1-fract) +  PALLETTE[idx2+1][0] * fract;
    rgb[1] = PALLETTE[idx2][1] * (1-fract) +  PALLETTE[idx2+1][1] * fract;
    rgb[2] = PALLETTE[idx2][2] * (1-fract) +  PALLETTE[idx2+1][2] * fract;
    
    
    int a = 255;
    int r = clamp(rgb[0] * radn) & 0xFF;
    int g = clamp(rgb[1] * radn) & 0xFF;
    int b = clamp(rgb[2] * radn) & 0xFF;
    
    int col = a << 24 | r << 16 | g << 8 | b;
    
   
    if(!isOccupied){
      setColor(col);
    }
    else{
      setColor(0xFF000000);
    }
    
    
    //if (idx == 0){
    //  setColor(0xFF00FFFF);
    //}
    
    //if (idx == 1 || idx == 2 || idx == 3 || idx == 4) setColor(0xFFFFFF00);
    
    //if (idx < 27) setColor(0xFFFF0000);
    
    //if (idx == 5) setColor(0xFFFFFFFF);
    //if (idx == 6) setColor(0xFFFFFF00);
    
    
    
    //this not working dunno why
    //if (idx > 6000){
    //  setColor(0xFFFFFFFF);
    //}
    
  }
   
  
  public float DAMP_VELOCITY = 0.4f;
  
  @Override
  public void updatePosition(float timestep) {

    if(enable_forces){
      // velocity
      float vx = (cx - px) * DAMP_VELOCITY;
      float vy = (cy - py) * DAMP_VELOCITY;
      
      px = cx;
      py = cy;
          
      // clamp velocity
      float vv_cur = vx*vx + vy*vy;
      float vv_max = rad_collision * rad_collision * 8;
      if(vv_cur > vv_max){
        float damp = (float) Math.sqrt(vv_max / vv_cur);
        vx *= damp;
        vy *= damp;
      }
      
      // verlet integration
      cx += vx + ax * 0.5 * timestep * timestep;
      cy += vy + ay * 0.5 * timestep * timestep;
    }
    ax = ay = 0;
  }
 
}
