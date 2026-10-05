package model;

public class Cart {
    private Product product;
    private int quantity;
    private String size = "M";
    private String color = "Tiêu chuẩn";

    public Cart() {}
    public Cart(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }
    public Cart(Product product, int quantity, String size, String color) {
        this.product = product;
        this.quantity = quantity;
        this.size = size;
        this.color = color;
    }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }
    public double getTotal() { return product != null ? product.getPrice() * quantity : 0; }
}