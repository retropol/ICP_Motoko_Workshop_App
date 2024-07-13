import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Principal "mo:base/Principal";

actor SocialMedia {
  type Post = {
    author : Principal;
    content : Text;
    timestamp : Time.Time;
  };

  func natHash(n : Nat) : Hash.Hash {
    Text.hash(Nat.toText(n));
  };

  var posts = Map.HashMap<Nat, Post>(0, Nat.equal, natHash); // HashMap which the post IDs relate to
  var nextId : Nat = 0; // the variable that holds the next post's ID
  let principal1 = Principal.fromText("aaaaa-aa");

  // Tüm gönderileri getirme işlemi
  public query func getPosts() : async [(Nat, Post)] {
    // Tüm gönderileri döndüren query fonksiyonu
    Iter.toArray(posts.entries()); // HashMap içindeki tüm gönderileri diziye dönüştürüyor
  };

  // Yeni gönderi ekleme işlemi
  public shared func addPost(content : Text) : async Text {
    // Yeni gönderi ekleyen fonksiyon
    let id = nextId; // Yeni gönderi ID'si oluşturuluyor
    posts.put(id, { author = principal1; content = content; timestamp = Time.now() }); // Gönderi HashMap'e ekleniyor
    nextId += 1; // Bir sonraki gönderi ID'si artırılıyor
    "Gönderi başarıyla eklendi. Gönderi ID'si: " # Nat.toText(id); // Sonuç metni döndürülüyor
  };

  // Belirli bir gönderiyi görüntüleme işlemi
  public query func viewPost(id : Nat) : async ?Post {
    // Belirli bir gönderiyi döndüren query fonksiyonu
    posts.get(id); // Gönderiyi ID'si ile getiriyor
  };

  // Tüm gönderileri temizleme işlemi
  public func clearPosts() : async () {
    // Tüm gönderileri temizleyen fonksiyon
    for (key : Nat in posts.keys()) {
      // HashMap içindeki tüm anahtarları alıyor
      ignore posts.remove(key); // Gönderileri temizliyor
    };
  };

  // Belirli bir gönderiyi güncelleme işlemi
  public shared func updatePost(id : Nat, newContent : Text) : async Text {
    // Gönderiyi güncelleyen fonksiyon
    switch (posts.get(id)) {
      case (?post) {
        if (post.author == principal1) {
          posts.put(id, { author = post.author; content = newContent; timestamp = Time.now() });
          "Gönderi başarıyla güncellendi. Gönderi ID'si: " # Nat.toText(id);
        } else {
          "Hata: Sadece kendi gönderinizi güncelleyebilirsiniz.";
        };
      };
      case null {
        "Hata: Gönderi bulunamadı.";
      };
    };
  };

  // Belirli bir gönderiyi silme işlemi
  public shared func deletePost(id : Nat) : async Text {
    // Gönderiyi silen fonksiyon
    switch (posts.get(id)) {
      case (?post) {
        if (post.author == principal1) {
          ignore posts.remove(id);
          "Gönderi başarıyla silindi. Gönderi ID'si: " # Nat.toText(id);
        } else {
          "Hata: Sadece kendi gönderinizi silebilirsiniz.";
        };
      };
      case null {
        "Hata: Gönderi bulunamadı.";
      };
    };
  };

};
