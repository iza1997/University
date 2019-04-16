using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class gameinspector : MonoBehaviour {

    public static int hits = 0;
    public static int sumofhits=0;
    
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        GetComponent<Text>().text ="Hits: " + hits.ToString();

	}
}
