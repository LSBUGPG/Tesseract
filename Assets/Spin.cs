using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spin : MonoBehaviour {

    public float speed = 1.0f;
    float rotation = 0.0f;

	void Update () {

        rotation += Time.deltaTime * speed;
        transform.rotation = Quaternion.Euler(rotation * 0.5f, rotation, 0.0f);
	}
}
