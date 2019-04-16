using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Obrót : MonoBehaviour {

    public GameObject title;

	
	void Update () {

       transform.Rotate(new Vector3(40, 0, 0) * Time.deltaTime);
	}
}
