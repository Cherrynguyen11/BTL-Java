package model;

public class CartItem {
    private Product product;
    private ProductVariant variant;
    private String size;
    private String color;
    private int quantity;

    public CartItem() {}

    public CartItem(Product product, ProductVariant variant, String size, String color, int quantity) {
        this.product = product;
        this.variant = variant;
        this.size = size;
        this.color = color;
        this.quantity = quantity;
    }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public ProductVariant getVariant() { return variant; }
    public void setVariant(ProductVariant variant) { this.variant = variant; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getSubtotal() {
        return product != null ? product.getPrice() * quantity : 0;
    }

    public String getItemKey() {
        return product.getId() + "_" + (size != null ? size : "") + "_" + (color != null ? color : "");
    }
}
