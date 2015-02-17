import java.util.ArrayList;

//Array list with an extended get method that re-maps out of bounds indexes

public class CircularArrayList<E> extends ArrayList<E> {

  @Override
  public E get(int index) {
    
    //If out of bounds to Left, Re-map it to within bounds
    if(index < 0){
      return super.get(size() + index);
      
    //If out of bounds to right, re-map from left however many left
    }else if(index >= size()){
      return super.get(index - size());
    }
    
    //Otherwise work just the same
    return super.get(index);
  }
}
