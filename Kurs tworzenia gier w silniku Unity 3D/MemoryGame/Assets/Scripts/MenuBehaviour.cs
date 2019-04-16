using System.Collections;
using UnityEngine.SceneManagement;
using UnityEngine;

public class MenuBehaviour : MonoBehaviour {

    public void triggerMenuBehaviour(int i){
        switch(i)
        {
            default:
            case(0):
                SceneManager.LoadScene("Level");
                break;
            case(1):
                Application.Quit();
                break;

        }
    }
}
