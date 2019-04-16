using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class ballcontroler : MonoBehaviour {

    public GameObject ball;
    public Vector3 currentpoint;
    public Vector3 dragPlaneNormal = Vector3.up;
    private Plane dragPlane;
    public Vector3 mousePos3D;
    public Vector3 oldMouse;
    private Vector3 mouseSpeed;
    public Ray mouseray;
    public bool moving = false;
    private Vector3 lastposition;
    public float dragdistance;
    private float magMultiplier = 5;
    private Vector3 startposition;
    public Vector3 forceVector;
    public AudioSource source;
    public AudioClip audioBallHit;
    public AudioClip ballhitswall;

    bool mousedrag = false;
    void Start () {
        dragPlane = new Plane(dragPlaneNormal, transform.position);
        startposition = transform.position;
        source.Play();
    }

    // Update is called once per frame
    void Update() {
        if (Input.GetKeyDown("r")){
            ball.GetComponent<Rigidbody>().velocity = Vector3.zero;
            transform.position = startposition;
        }
        
        ismoving();

    }
    private void ismoving()
    {
        if(ball.GetComponent<Rigidbody>().velocity.magnitude < 0.15)
        {
            moving = false;
            ball.GetComponent<Rigidbody>().velocity = Vector3.zero;
            return;
        }
        moving = true;
        return;
    }
     void OnMouseDown()
    {
        if(moving)
        {
            return;
        }
        lastposition = transform.position;
        mousedrag = true;
        dragPlane = new Plane(dragPlaneNormal, transform.position);


    }
     void OnMouseDrag()
    {
        if (moving)
        {
            return;
        }
        if (dragPlane.GetDistanceToPoint(transform.position) != 0)
        {
            
            dragPlane = new Plane(dragPlaneNormal, transform.position);
        }
        mouseray = Camera.main.ScreenPointToRay(Input.mousePosition);
        float intersectDist = 0.0f;

        if (dragPlane.Raycast(mouseray, out intersectDist))
        {
            mousePos3D = mouseray.GetPoint(intersectDist);
            dragdistance = Mathf.Clamp((mousePos3D - transform.position).magnitude, 0, 3.0f);
            forceVector = mousePos3D - transform.position;
            forceVector.Normalize();
            forceVector *= dragdistance * magMultiplier;
            
            
        }


    }
     void OnMouseUp()
    {
        if (moving)
        {
            return;
        }
        mousedrag = false;
        int snapD = -1;
        GetComponent<Rigidbody>().AddForce(snapD * forceVector, ForceMode.VelocityChange);
        source.PlayOneShot(audioBallHit);
        gameinspector.hits += 1;
        Debug.Log(gameinspector.hits);
        


    }
    private void OnTriggerEnter(Collider other)
    {
        if(other.name=="dolek1")
        {
            gameinspector.sumofhits += gameinspector.hits;
            gameinspector.hits = 0;
            SceneManager.LoadScene("plansza2");
        }
        if(other.name=="dolek2")
        {
            gameinspector.sumofhits += gameinspector.hits;
            gameinspector.hits = 0;
            SceneManager.LoadScene("plansza3");
        }
        if (other.name == "dolek3")
        {
            gameinspector.sumofhits += gameinspector.hits;
            gameinspector.hits = 0;
            SceneManager.LoadScene("koniec");
        }
        if (other.tag=="Wall")
        {
            
            source.PlayOneShot(ballhitswall);
        }
        if(other.tag=="Plane")
        {
            ball.GetComponent<Rigidbody>().velocity = Vector3.zero;
            transform.position = lastposition;
        }
    }
   
    void OnGUI()
    {
        if (mousedrag)
        {
            Vector2 guiMouseCoord = GUIUtility.ScreenToGUIPoint(Input.mousePosition);
            GUI.Box(new Rect(guiMouseCoord.x - 30, Screen.height - guiMouseCoord.y + 15, 100, 20), "sila: " + Mathf.Round((forceVector).magnitude));
        }
    }
}
