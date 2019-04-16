using System.Collections;
using UnityEngine.UI;
using UnityEngine;
using UnityEngine.Audio;
using UnityEditor;


public class Duszek : MonoBehaviour
{


    public Transform[] wayPoints;
    public float speed = 0.3f;
    private int cur = 0;
    public Text lostText;
    public static bool celDuszek = false;
    bool home = false;
    public static bool greenDuszek = false;
    public int time;
    public RuntimeAnimatorController ghostBlue;
    public RuntimeAnimatorController ghostRed;
    private Vector2 position;
    public AudioClip audioDeath;
    public AudioClip audioDuszekDeath;
    public AudioSource source;
    public AudioClip audioDirection;



    private void Start()
    {
        position = gameObject.transform.position;
        lostText.text = "";
        startCheck();
    }




    private void FixedUpdate()
    {
        if (!home)
        {
            if (transform.position.x != wayPoints[cur].position.x || transform.position.y != wayPoints[cur].position.y)
            {
                Vector2 p = Vector2.MoveTowards(transform.position, wayPoints[cur].position, speed);
                GetComponent<Rigidbody2D>().MovePosition(p);
            }
            else
            {
                cur = (cur + 1) % wayPoints.Length;
            }
        }
        if (celDuszek)
        {
            transform.GetComponent<Animator>().runtimeAnimatorController = ghostBlue;
        }
        else
        {
            transform.GetComponent<Animator>().runtimeAnimatorController = ghostRed;
        }

    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.name == "Pacman" && celDuszek == false )
        {
            if (gameObject.tag == "Duszek")
            {
                Destroy(collision.gameObject);
                lostText.text = "You lost!";
                source.PlayOneShot(audioDeath);
            }
            else {
                source.PlayOneShot(audioDirection);
                changeDirection();
            }
        }
        if (collision.name == "Pacman" && celDuszek == true)
        {
            GetComponent<Rigidbody2D>().MovePosition(position);
            cur = 0;
            source.PlayOneShot(audioDuszekDeath);
            changeScale();
            time = 10;
            startCheck();
        }
    }


    public void changeDirection()
    {
        StartCoroutine(pause3());
    }

    IEnumerator pause3()
    {
        greenDuszek = true;
        yield return new WaitForSeconds(5);
        greenDuszek = false;

    }

    public void changeScale()
    {
        StartCoroutine(pause2());
    }


    IEnumerator pause2()
    {
        transform.localScale += new Vector3(3, 3, 3);
        yield return new WaitForSeconds(0.2f);
        transform.localScale -= new Vector3(3, 3, 3);
        yield return new WaitForSeconds(0.1f);
        transform.localScale += new Vector3(2, 2, 2);
        yield return new WaitForSeconds(0.1f);
        transform.localScale -= new Vector3(2, 2, 2);


    }


    public void startCheck()
    {
        StartCoroutine(pause());
    }

    IEnumerator pause()
    {
        home = true;
        yield return new WaitForSeconds(time);
        home = false;


    }



}
