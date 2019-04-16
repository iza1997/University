using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Audio;





public class Pacman : MonoBehaviour
{

    public float speed = 0.4f;
    private Vector2 dest = Vector2.zero;
    public Text countText;
    public Text lostText;
    public int count;
    public GameObject[] duszki;
    public static bool shouldExecute;
    public AudioClip audioPunkt;
    public AudioClip audioWin;
    public AudioSource source;
    public AudioSource source1;



    public Text readyText;


    private void Start()
    {
        winText.text = "";
        dest = transform.position;
        count = 0;
        SetCountText();
        lostText.text = "";
        readyText.text = "";
        StartCoroutine(pause1());

    }

    IEnumerator pause1()
    {
        shouldExecute = false;
        yield return new WaitForSeconds(5);
        readyText.text = "READY!";
        shouldExecute = true;
        yield return new WaitForSeconds(2);
        Destroy(readyText);

    }


    void FixedUpdate()
    {
        if (shouldExecute == true)
        {
            if (Duszek.greenDuszek == false)
            {
                Vector2 p = Vector2.MoveTowards(transform.position, dest, speed);
                GetComponent<Rigidbody2D>().MovePosition(p);

                if (Input.GetKey(KeyCode.UpArrow))
                {
                    dest = (Vector2)transform.position + Vector2.up;
                    transform.eulerAngles = new Vector3(0, 0, 90);
                }
                else if (Input.GetKey(KeyCode.RightArrow))
                {
                    dest = (Vector2)transform.position + Vector2.right;
                    transform.eulerAngles = new Vector2(0, 0);
                }
                else if (Input.GetKey(KeyCode.LeftArrow))
                {
                    dest = (Vector2)transform.position + Vector2.left;
                    transform.eulerAngles = new Vector2(0, 180);
                }
                else if (Input.GetKey(KeyCode.DownArrow))
                {
                    dest = (Vector2)transform.position + Vector2.down;
                    transform.eulerAngles = new Vector3(0, 0, 270);
                }
            }
            else {
                Vector2 p = Vector2.MoveTowards(transform.position, dest, speed);
                GetComponent<Rigidbody2D>().MovePosition(p);

                if (Input.GetKey(KeyCode.UpArrow))
                {
                    dest = (Vector2)transform.position + Vector2.down;
                    transform.eulerAngles = new Vector3(0, 0, 270);

                }
                else if (Input.GetKey(KeyCode.RightArrow))
                {
                    dest = (Vector2)transform.position + Vector2.left;
                    transform.eulerAngles = new Vector2(0, 180);
                }
                else if (Input.GetKey(KeyCode.LeftArrow))
                {
                    dest = (Vector2)transform.position + Vector2.right;
                    transform.eulerAngles = new Vector2(0, 0);
                }
                else if (Input.GetKey(KeyCode.DownArrow))
                {
                    dest = (Vector2)transform.position + Vector2.up;
                    transform.eulerAngles = new Vector3(0, 0, 90);
                }
            }
        }
    }

    private void SetCountText()
    {
        countText.text = "Count: " + count.ToString();
        if (count >= 329)
        {
            lostText.text = "You Win!";
            lostText.color = Color.yellow;
            source1.Stop();
            source.PlayOneShot(audioWin);
            duszki = GameObject.FindGameObjectsWithTag("Duszek");
            foreach (GameObject duszek in duszki) {
                Destroy(duszek);
            }
            Destroy(GameObject.FindWithTag("DuszekGreen"));

        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.CompareTag("Punkt"))
        {
            Destroy(collision.gameObject);
            source.PlayOneShot(audioPunkt);
            count = count + 1;
            SetCountText();
        }
        if (collision.gameObject.CompareTag("PunktExtra"))
        {
            Destroy(collision.gameObject);
            count = count + 1;
            SetCountText();
            falseCheck();
        }

    }

    public void falseCheck()
    {
        StartCoroutine(pause());
    }

    IEnumerator pause()
    {
        Duszek.celDuszek = true;
        source1.Play(10);
        yield return new WaitForSeconds(10);
        source1.Stop();
        Duszek.celDuszek = false;
    }
}