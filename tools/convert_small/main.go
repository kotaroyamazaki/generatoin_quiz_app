package main

import (
	"context"
	"fmt"
	"log"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"
)

// Quiz represents the structure of each quiz item with JSON tags for lowercase field names
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

	// 対象のコレクションリスト
//	collections := []string{"2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023"}
	collections := []string{"2022"}

	for _, collectionName := range collections {
		err := updateCollectionFieldNames(ctx, client, collectionName)
		if err != nil {
			log.Printf("Failed to update collection %s: %v", collectionName, err)
		}
	}

	fmt.Println("フィールド名の整形が完了しました。")
}

// コレクション内のドキュメントフィールド名を小文字に変換する関数
func updateCollectionFieldNames(ctx context.Context, client *firestore.Client, collectionName string) error {
	iter := client.Collection(collectionName).Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return fmt.Errorf("failed to iterate documents: %v", err)
		}

		data := doc.Data()
		quiz := Quiz{
			Question:    fmt.Sprintf("%v", data["Question"]),
			Options:     convertToStringArray(data["Options"]),
			Answer:      fmt.Sprintf("%v", data["Answer"]),
			Explanation: fmt.Sprintf("%v", data["Explanation"]),
			Tags:        convertToStringArray(data["Tags"]),
		}

		_, err = client.Collection(collectionName).Doc(doc.Ref.ID).Set(ctx, quiz)
		if err != nil {
			return fmt.Errorf("failed to set document: %v", err)
		}
	}
	return nil
}

func convertToStringArray(data interface{}) []string {
	if arr, ok := data.([]interface{}); ok {
		strArr := make([]string, len(arr))
		for i, v := range arr {
			strArr[i] = fmt.Sprintf("%v", v)
		}
		return strArr
	}
	return []string{}
}
