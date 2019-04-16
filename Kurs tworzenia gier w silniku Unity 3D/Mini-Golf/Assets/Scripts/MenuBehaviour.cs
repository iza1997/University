using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuBehaviour : MonoBehaviour {

public void triggerMenuBehaviour(int i) {
        switch(i)
        {
            default:
            case (0):
                SceneManager.LoadScene("plansza1");
                break;
            case (1):
                Application.Quit();
                break;
        }
    }
}
