package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private int id;
    private String orderCode;
    private Integer userId;
    private String customerName;
    private String phone;
    private String address;
    private String channel = "WEBSITE"; // STORE_POS, WEBSITE, SHOPEE, TIKTOK
    private String paymentMethod = "COD"; // CASH, TRANSFER, COD
    private String paymentStatus = "UNPAID"; // PAID, UNPAID
    private double discountAmount = 0;
    private double totalAmount;
    private String status = "PENDING"; // PENDING, CONFIRMED, PROCESSING, SHIPPING, COMPLETED, CANCELLED
    private Integer staffId;
    private String staffName;
    private String notes;
    private Timestamp createdAt;
    private List<OrderDetail> items = new ArrayList<>();

    public Order() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getChannel() { return channel; }
    public void setChannel(String channel) { this.channel = channel; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    // Compatibility getter/setter for total
    public double getTotal() { return totalAmount; }
    public void setTotal(double total) { this.totalAmount = total; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getStaffId() { return staffId; }
    public void setStaffId(Integer staffId) { this.staffId = staffId; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<OrderDetail> getItems() { return items; }
    public void setItems(List<OrderDetail> items) { this.items = items; }

    public String getChannelBadgeClass() {
        if ("STORE_POS".equalsIgnoreCase(channel)) return "badge-pos";
        if ("WEBSITE".equalsIgnoreCase(channel)) return "badge-web";
        if ("SHOPEE".equalsIgnoreCase(channel)) return "badge-shopee";
        if ("TIKTOK".equalsIgnoreCase(channel)) return "badge-tiktok";
        return "badge-default";
    }

    public String getChannelLabel() {
        if ("STORE_POS".equalsIgnoreCase(channel)) return "Tại quầy POS";
        if ("WEBSITE".equalsIgnoreCase(channel)) return "Website Online";
        if ("SHOPEE".equalsIgnoreCase(channel)) return "Shopee Mall";
        if ("TIKTOK".equalsIgnoreCase(channel)) return "TikTok Shop";
        return channel;
    }

    public String getStatusBadgeClass() {
        if ("COMPLETED".equalsIgnoreCase(status)) return "status-completed";
        if ("SHIPPING".equalsIgnoreCase(status)) return "status-shipping";
        if ("PROCESSING".equalsIgnoreCase(status)) return "status-processing";
        if ("CONFIRMED".equalsIgnoreCase(status)) return "status-confirmed";
        if ("PENDING".equalsIgnoreCase(status)) return "status-pending";
        if ("CANCELLED".equalsIgnoreCase(status)) return "status-cancelled";
        return "status-default";
    }

    public String getStatusLabel() {
        if ("COMPLETED".equalsIgnoreCase(status)) return "Hoàn thành";
        if ("SHIPPING".equalsIgnoreCase(status)) return "Đang giao hàng";
        if ("PROCESSING".equalsIgnoreCase(status)) return "Đang đóng gói";
        if ("CONFIRMED".equalsIgnoreCase(status)) return "Đã xác nhận";
        if ("PENDING".equalsIgnoreCase(status)) return "Chờ xử lý";
        if ("CANCELLED".equalsIgnoreCase(status)) return "Đã hủy đơn";
        return status;
    }
}