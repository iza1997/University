using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour {

    
    public GameObject player;
    private Vector3 offset;
    public float rotateSpeed =5.0f;
    [Range(0.01f, 1.0f)]
    public float Smooth = 0.5f;
    public bool lookatplayer = true;
    public bool rotateAround = false;
    
    void Start()
    {
        offset = transform.position - player.transform.position;
    }
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Mouse1))
        {
            rotateAround = true;
        }
        if(Input.GetKeyUp(KeyCode.Mouse1))
        {
            rotateAround = false;
        }
       

    }


    void LateUpdate()
    {
        if (rotateAround)
        {
            Quaternion camTurnAngle = Quaternion.AngleAxis(Input.GetAxis("Mouse X")*rotateSpeed,Vector3.up);
            offset = camTurnAngle * offset;
        }
        Vector3 newPos = player.transform.position - offset;
        transform.position = Vector3.Slerp(transform.position, newPos, Smooth);
        if(lookatplayer || rotateAround)
        {
            transform.LookAt(player.transform);
        }

    }
}


