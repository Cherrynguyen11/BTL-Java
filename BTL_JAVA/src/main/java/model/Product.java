package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Product {
    private int id;
    private int categoryId;
    private String categoryName;
    private String name;
    private String description;
    private double price;
    private double originalPrice;
    private String image;
    private int status = 1;
    private Timestamp createdAt;
    private int stock;
    private List<ProductVariant> variants = new ArrayList<>();

    public Product() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(double originalPrice) { this.originalPrice = originalPrice; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public List<ProductVariant> getVariants() { return variants; }
    public void setVariants(List<ProductVariant> variants) { this.variants = variants; }

    public int getDiscountPercent() {
        if (originalPrice > price && originalPrice > 0) {
            return (int) Math.round((originalPrice - price) / originalPrice * 100);
        }
        return 0;
    }
}