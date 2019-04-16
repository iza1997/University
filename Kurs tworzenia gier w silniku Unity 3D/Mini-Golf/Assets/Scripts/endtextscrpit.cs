using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class endtextscrpit : MonoBehaviour {
    private int copyhits = 0;
	// Use this for initialization
	void Start () {
		copyhits=gameinspector.sumofhits;
	}

    // Update is called once per frame
    void Update()
    {
        GetComponent<Text>().text = "Your score: " + copyhits.ToString()+ " hits";
        gameinspector.sumofhits = 0;
    }
}
