/*
 * Recognizer
 * @author Jonathan Simon Prates (jonathan.simonprates@gmail.com)
 */
 
public class Recognizer
{
  private PVector lastHandPosition;
  private SimpleQueue<Float> moves;
  private DTW dtw;
  private Map<String, Float[]> gestures;
  private Float maxThreshold;
  private int pixelsMinDiff = 10;
  private int gesturesBufferSize;

  public Recognizer() 
  {
    maxThreshold = 0.01F;
    gesturesBufferSize = 15;
    gestures = new HashMap<String, Float[]>();
    moves = new SimpleQueue<Float>();
    gestures.put("Quadrado", new Float[] {
      1.0F, 1.0F, 1.0F, 1.0F, 3.0F, 3.0F, 3.0F, 3.0F, 2.0F, 2.0F, 2.0F, 2.0F, 4.0F, 4.0F, 4.0F
    }
    );
    gestures.put("+Vol", new Float[] {
      4.0F, 4.0F, 4.0F, 4.0F, 1.0F, 1.0F, 1.0F, 1.0F, 1.0F, 1.0F, 1.0F, 1.0F, 1.0F, 1.0F, 1.0F
    }
    );
    gestures.put("-Vol", new Float[] {
      4.0F, 4.0F, 4.0F, 4.0F, 2.0F, 2.0F, 2.0F, 2.0F, 2.0F, 2.0F, 2.0F, 2.0F, 2.0F, 2.0F, 2.0F
    }
    );
  }

  //from User Tracker - sample program (Java) - OpenNI example.
  void drawSkeleton(SimpleOpenNI context, int userId)
  {  
    stroke(0, 0, 255);
    strokeWeight(3);
    smooth();

    context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  }
  public String findGesture(SimpleOpenNI _context, boolean _draw) 
  {
    int userId = 0;
    int i;

    for (i = 1; i < 10; i++) {
      if (_context.isTrackingSkeleton(i)) {
        if (_draw)
          drawSkeleton(_context, i);
        userId = i;
        break;
      }
    }

    if (userId == 0)
      return null;

    PVector jointNeck3D = new PVector();
    PVector jointLeftShoulder3D = new PVector();
    PVector jointLeftElbow3D = new PVector();
    PVector jointLeftHand3D = new PVector();
    PVector jointRightShoulder3D = new PVector();
    PVector jointRightElbow3D = new PVector();
    PVector jointRightHand3D = new PVector();
    PVector jointNeck2D = new PVector();  
    PVector jointLeftShoulder2D = new PVector();
    PVector jointLeftElbow2D = new PVector();
    PVector jointLeftHand2D = new PVector();
    PVector jointRightShoulder2D = new PVector();
    PVector jointRightElbow2D = new PVector();
    PVector jointRightHand2D = new PVector();

    _context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, jointNeck3D);  
    _context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, jointLeftShoulder3D);
    _context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, jointLeftElbow3D);
    _context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, jointLeftHand3D);
    _context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, jointRightShoulder3D);
    _context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, jointRightElbow3D);
    _context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, jointRightHand3D);
    _context.convertRealWorldToProjective(jointNeck3D, jointNeck2D);
    _context.convertRealWorldToProjective(jointLeftShoulder3D, jointLeftShoulder2D);
    _context.convertRealWorldToProjective(jointLeftElbow3D, jointLeftElbow2D);
    _context.convertRealWorldToProjective(jointLeftHand3D, jointLeftHand2D);
    _context.convertRealWorldToProjective(jointRightShoulder3D, jointRightShoulder2D);
    _context.convertRealWorldToProjective(jointRightElbow3D, jointRightElbow2D);
    _context.convertRealWorldToProjective(jointRightHand3D, jointRightHand2D);

    //I am considering one hand only
    if (this.lastHandPosition == null)
    {
      this.lastHandPosition = jointRightHand2D;
      return null;
    }

    float move = 0;
    float xdiff = lastHandPosition.x - jointRightHand2D.x;
    float ydiff = lastHandPosition.y - jointRightHand2D.y;   
    if (abs(xdiff) > pixelsMinDiff)
    {
      if (xdiff < 0)
        move += 1; //to right
      else
        move += 2; //to left
    }

    if (abs(ydiff) > pixelsMinDiff)
    {
      if (ydiff < 0)
        move += 3;//to down;
      else
        move += 4;//to up
    }

    if (move != 0)
    {
      println(move);
      moves.put(move) ;
      if (moves.size() > gesturesBufferSize) moves.get();
    }
    lastHandPosition = jointRightHand2D;
    return recognizeWithDTW();
  }

  private String recognizeWithDTW()
  {
    if (moves.size() < gesturesBufferSize -1) {
      return null;
    }

    String _gestureName = "";
    Float[] data =  moves.toArray();

    double minDist = Double.POSITIVE_INFINITY;
    Iterator i = gestures.entrySet().iterator();
    while (i.hasNext ())
    {
      Map.Entry me = (Map.Entry)i.next();
      Float[] example = (Float[]) me.getValue();
      dtw = new DTW(example, data);
      double distance = dtw.getDistance() / data.length;
      if (distance < minDist)
      {
        minDist = distance;
        _gestureName = (String)me.getKey();
      }

      if (minDist < maxThreshold)
      {
        moves.clear();
        return _gestureName;
      }
    }
    return null;
  }
}