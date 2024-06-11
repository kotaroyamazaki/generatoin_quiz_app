package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/option"
)

// Quiz represents the structure of each quiz item
type Quiz struct {
	Question    string   `json:"question" firestore:"Question"`
	Options     []string `json:"options" firestore:"Options"`
	Answer      string   `json:"answer" firestore:"Answer"`
	Explanation string   `json:"explanation" firestore:"Explanation"`
	Tags        []string `json:"tags" firestore:"Tags"`
}

func main() {
	// Firestoreクライアントの初期化
	ctx := context.Background()
	sa := option.WithCredentialsFile("../fb_credential.json")
	client, err := firestore.NewClient(ctx, "generation-quiz", sa)
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	defer client.Close()

	// JSONファイルのディレクトリパス
	jsonDir := "../../assets/quizzes"

	// ディレクトリ内のすべてのJSONファイルを読み込んでFirestoreに保存
	err = filepath.Walk(jsonDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		fmt.Printf("Uploading %s...\n", path)
		if strings.HasSuffix(info.Name(), ".json") {
			collectionName := strings.TrimSuffix(info.Name(), filepath.Ext(info.Name()))
			err := uploadJSONToFirestore(client, path, collectionName)
			if err != nil {
				log.Printf("Failed to upload %s: %v", path, err)
			}

	}
		return nil
	})

	if err != nil {
		log.Fatalf("Failed to walk through jsonDir: %v", err)
	}

	fmt.Println("データのアップロードが完了しました。")
}

// JSONファイルをFirestoreにアップロードする関数
func uploadJSONToFirestore(client *firestore.Client, filePath string, collectionName string) error {
	data, err := ioutil.ReadFile(filePath)
	if err != nil {
		return fmt.Errorf("failed to read file %s: %v", filePath, err)
	}

	var quizzes []Quiz
	if err := json.Unmarshal(data, &quizzes); err != nil {
		return fmt.Errorf("failed to unmarshal JSON: %v", err)
	}

	ctx := context.Background()
	for _, quiz := range quizzes {
		_, _, err := client.Collection(collectionName).Add(ctx, quiz)
		if err != nil {
			return fmt.Errorf("failed to add document to Firestore: %v", err)
		}
	}
	return nil
}
