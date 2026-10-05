<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thu Ngân Bán Tại Quầy (Store POS) - FashionStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .pos-header-bar {
            background: #0f172a;
            color: white;
            padding: 0.75rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .variant-mini-select {
            font-size: 0.75rem;
            padding: 2px 4px;
            border-radius: 4px;
            border: 1px solid var(--border);
            margin-top: 4px;
            width: 100%;
        }
    </style>
</head>
<body style="overflow: hidden;">

    <!-- Top Bar -->
    <div class="pos-header-bar">
        <div style="display: flex; align-items: center; gap: 1rem;">
            <a href="${pageContext.request.contextPath}/admin?page=dashboard" class="btn btn-outline btn-sm" style="padding: 0.3rem 0.6rem; font-size: 0.8rem;">
                ← Dashboard
            </a>
            <span style="font-weight: 800; letter-spacing: -0.5px; font-size: 1.1rem; color: #fcd34d;">
                🏪 POS SHOWROOM BÀ TRIỆU
            </span>
            <span class="badge badge-pos" style="background: rgba(16, 185, 129, 0.2); color: #34d399; border: 1px solid #059669;">
                Kênh Bán Tại Quầy (STORE_POS)
            </span>
        </div>

        <div style="display: flex; align-items: center; gap: 1.5rem; font-size: 0.85rem;">
            <span>Thu ngân: <b style="color: #fcd34d;">${sessionScope.user.fullName}</b></span>
            <span id="posClock" style="font-family: monospace; font-weight: 700; color: #94a3b8;"></span>
            <a href="${pageContext.request.contextPath}/home" target="_blank" class="btn btn-outline btn-sm">Xem Web ↗</a>
        </div>
    </div>

    <!-- POS Split View -->
    <div class="pos-container" id="posContainer">

        <!-- Left Column: Product Catalog -->
        <div class="pos-catalog" id="posCatalog">
            <!-- Search & Barcode -->
            <div class="pos-search-bar">
                <input type="text" id="posSearch" placeholder="🔍 Quét mã vạch hoặc nhập tên sản phẩm thời trang..." onkeyup="filterPosProducts()">
            </div>

            <!-- Categories Chips -->
            <div class="pos-categories-chips">
                <div class="pos-chip active" onclick="filterCategory('ALL', this)">Tất Cả Danh Mục</div>
                <c:forEach var="c" items="${categories}">
                    <div class="pos-chip" onclick="filterCategory('${c.id}', this)">${c.icon} ${c.name}</div>
                </c:forEach>
            </div>

            <!-- Product Cards Grid -->
            <div class="pos-grid" id="posProductGrid">
                <c:forEach var="p" items="${products}">
                    <div class="pos-item-card" data-cat="${p.categoryId}" data-name="${p.name.toLowerCase()}">
                        <img src="${p.image}" alt="${p.name}">
                        <div style="font-size: 0.75rem; color: var(--accent); font-weight: 700; text-transform: uppercase;">
                            ${p.categoryName}
                        </div>
                        <div style="font-weight: 700; font-size: 0.875rem; color: var(--primary-dark); line-height: 1.25; margin: 0.25rem 0; height: 2.2rem; overflow: hidden;">
                            ${p.name}
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: baseline; margin-top: auto;">
                            <span style="font-weight: 800; color: var(--danger); font-size: 0.95rem;">
                                <fmt:formatNumber value="${p.price}" pattern="#,###"/> ₫
                            </span>
                            <span style="font-size: 0.75rem; color: var(--text-muted);">Kho: <b>${p.stock}</b></span>
                        </div>

                        <!-- Variant Picker Dropdown -->
                        <select class="variant-mini-select" id="var_select_${p.id}">
                            <c:forEach var="v" items="${p.variants}">
                                <option value="${v.id}" data-size="${v.size}" data-color="${v.color}" data-stock="${v.quantity}">
                                    Size ${v.size} - ${v.color} (Còn ${v.quantity})
                                </option>
                            </c:forEach>
                            <c:if test="${empty p.variants}">
                                <option value="0" data-size="Freesize" data-color="Tiêu chuẩn" data-stock="${p.stock}">
                                    Freesize - Tiêu chuẩn
                                </option>
                            </c:if>
                        </select>

                        <button type="button" class="btn btn-dark btn-sm" style="margin-top: 0.5rem;" onclick="addToPosBill(${p.id}, '${p.name}', ${p.price}, '${p.image}')">
                            + Thêm Vào Bill
                        </button>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Draggable Resizer Bar (Thanh kéo co giãn kích thước hóa đơn) -->
        <div id="posResizer" class="pos-resizer" title="Kéo sang trái/phải để điều chỉnh độ rộng hóa đơn">
            <div class="pos-resizer-handle"></div>
        </div>

        <!-- Right Column: Current Bill & Checkout -->
        <div class="pos-cart-panel" id="posCartPanel">
            <form id="posCheckoutForm" action="${pageContext.request.contextPath}/pos" method="post" style="display: flex; flex-direction: column; height: 100%; min-height: 0; overflow: hidden;">
                <div class="pos-cart-header" style="flex-shrink: 0;">
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 800; color: var(--primary-dark); margin: 0;">Hóa Đơn Hiện Tại</h3>
                        <span id="posItemCountBadge" class="badge" style="background: #e2e8f0; color: var(--primary-dark); font-size: 0.75rem; border-radius: 12px; padding: 2px 8px; font-weight: 700;">0 món</span>
                    </div>
                    <button type="button" class="btn btn-outline-dark btn-sm" onclick="clearPosBill()" style="color: var(--danger); border-color: var(--danger);">
                        Xóa Bill
                    </button>
                </div>

                <!-- Customer Input -->
                <div style="flex-shrink: 0; padding: 0.75rem 1.25rem; background: #f8fafc; border-bottom: 1px solid var(--border); display: grid; grid-template-columns: 1.2fr 1fr; gap: 0.75rem;">
                    <input type="text" name="customerName" placeholder="Tên khách hàng (hoặc Khách lẻ)" value="Khách lẻ tại quầy" style="padding: 0.4rem 0.6rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.85rem;">
                    <input type="tel" name="phone" placeholder="Số điện thoại..." value="0905123456" style="padding: 0.4rem 0.6rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.85rem;">
                </div>

                <!-- Bill Items List -->
                <div class="pos-cart-items" id="posBillContainer">
                    <div id="emptyBillNotice" style="text-align: center; color: var(--text-muted); padding: 3rem 1rem;">
                        <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">🛒</div>
                        <p style="font-size: 0.875rem;">Chưa có sản phẩm nào trong hóa đơn.<br>Nhấp chọn sản phẩm bên trái để bắt đầu bán.</p>
                    </div>
                </div>

                <!-- Bill Footer & Payment Calculation -->
                <div class="pos-cart-footer">
                    <div class="pos-summary-row">
                        <span>Tổng tiền hàng:</span>
                        <span id="posSubtotalText" style="font-weight: 700;">0 ₫</span>
                    </div>

                    <div class="pos-summary-row" style="align-items: center;">
                        <span>Chiết khấu / Giảm giá:</span>
                        <div style="display: flex; align-items: center; gap: 0.3rem;">
                            <input type="number" name="discount" id="posDiscount" value="0" min="0" step="5000" oninput="recalcBill()" style="width: 100px; padding: 0.3rem 0.5rem; border: 1px solid var(--border); border-radius: 4px; text-align: right; font-weight: 700;">
                            <span>₫</span>
                        </div>
                    </div>

                    <div class="pos-summary-row total">
                        <span>Khách Cần Trả:</span>
                        <span id="posFinalTotalText" style="color: var(--danger);">0 ₫</span>
                    </div>

                    <!-- Payment Mode -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.5rem; margin-bottom: 0.5rem;">
                        <label style="display: flex; align-items: center; justify-content: center; gap: 0.4rem; padding: 0.45rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.85rem; font-weight: 700; cursor: pointer; background: white;" id="cashTab">
                            <input type="radio" name="paymentMethod" value="CASH" checked onchange="togglePayMode('CASH')">
                            💵 Tiền mặt
                        </label>
                        <label style="display: flex; align-items: center; justify-content: center; gap: 0.4rem; padding: 0.45rem; border: 1px solid var(--border); border-radius: 6px; font-size: 0.85rem; font-weight: 700; cursor: pointer; background: white;" id="transferTab">
                            <input type="radio" name="paymentMethod" value="TRANSFER" onchange="togglePayMode('TRANSFER')">
                            📱 Quẹt QR
                        </label>
                    </div>

                    <!-- Cash received / Change Calculation -->
                    <div id="cashCalcBox" style="background: white; border: 1px solid var(--border); border-radius: 6px; padding: 0.5rem 0.75rem; margin-bottom: 0.75rem; font-size: 0.85rem;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.35rem;">
                            <span>Tiền khách đưa:</span>
                            <input type="number" id="cashGiven" value="0" step="10000" oninput="calcChange()" style="width: 120px; padding: 0.3rem 0.5rem; border: 1px solid var(--border); border-radius: 4px; text-align: right; font-weight: 700; color: var(--primary-dark);">
                        </div>
                        <div style="display: flex; justify-content: space-between; font-weight: 700;">
                            <span>Tiền thừa trả khách:</span>
                            <span id="cashChangeText" style="color: var(--success); font-size: 0.95rem;">0 ₫</span>
                        </div>
                    </div>

                    <button type="submit" id="posSubmitBtn" class="btn btn-success btn-block" style="padding: 0.75rem 1rem; font-size: 1rem; font-weight: 700;" disabled>
                        ⚡ Thanh Toán &amp; In Hóa Đơn (F9)
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Receipt Print Modal (Shown after successful POS checkout) -->
    <c:if test="${checkoutSuccess && not empty posOrder}">
        <div id="receiptModal" style="position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 9999; display: flex; align-items: center; justify-content: center;">
            <div style="background: white; border-radius: var(--radius); padding: 2rem; max-width: 420px; width: 100%; box-shadow: var(--shadow-xl);">
                <div class="receipt-print-area">
                    <div class="receipt-header">
                        <h2 style="font-size: 16px; font-weight: bold;">✦ FASHIONSTORE ✦</h2>
                        <div>Showroom Vincom Bà Triệu, Hà Nội</div>
                        <div>Hotline: 1900 8888</div>
                        <div style="margin: 6px 0; border-top: 1px dashed black;"></div>
                        <div><b>HÓA ĐƠN BÁN LẺ TẠI QUẦY</b></div>
                        <div>Mã HĐ: <b>${posOrder.orderCode}</b></div>
                        <div>Ngày: <fmt:formatDate value="${posOrder.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                        <div>Thu ngân: ${posOrder.staffName}</div>
                        <div>Khách hàng: ${posOrder.customerName}</div>
                    </div>

                    <div style="border-bottom: 1px dashed black; padding-bottom: 4px; margin-bottom: 4px; font-weight: bold; display: flex; justify-content: space-between;">
                        <span>Mặt hàng</span>
                        <span>T.Tiền</span>
                    </div>

                    <c:forEach var="item" items="${posOrder.items}">
                        <div class="receipt-item-row">
                            <div>
                                <div>${item.productName}</div>
                                <div style="font-size: 11px; color: #555;">${item.size} / ${item.color} x${item.quantity}</div>
                            </div>
                            <div><fmt:formatNumber value="${item.subtotal}" pattern="#,###"/></div>
                        </div>
                    </c:forEach>

                    <div class="receipt-total">
                        <div class="receipt-item-row">
                            <span>Giảm giá:</span>
                            <span>-<fmt:formatNumber value="${posOrder.discountAmount}" pattern="#,###"/> đ</span>
                        </div>
                        <div class="receipt-item-row" style="font-size: 14px; font-weight: bold;">
                            <span>TỔNG CỘNG:</span>
                            <span><fmt:formatNumber value="${posOrder.totalAmount}" pattern="#,###"/> đ</span>
                        </div>
                        <div class="receipt-item-row">
                            <span>Hình thức:</span>
                            <span>${posOrder.paymentMethod} (Đã thanh toán)</span>
                        </div>
                    </div>

                    <div style="text-align: center; margin-top: 12px; font-size: 11px;">
                        <div>Cảm ơn quý khách &amp; Hẹn gặp lại!</div>
                        <div>Đổi size/mẫu trong vòng 30 ngày kèm hóa đơn.</div>
                        <div style="margin-top: 6px;">*** www.fashionstore.vn ***</div>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                    <button type="button" onclick="window.print()" class="btn btn-primary" style="flex: 1;">
                        🖨️ In Hóa Đơn
                    </button>
                    <button type="button" onclick="closeReceiptModal()" class="btn btn-outline-dark" style="flex: 1;">
                        Đóng &amp; Tiếp tục bán
                    </button>
                </div>
            </div>
        </div>
    </c:if>

    <script>
        // Clock
        setInterval(() => {
            const now = new Date();
            document.getElementById('posClock').innerText = now.toLocaleTimeString('vi-VN') + ' ' + now.toLocaleDateString('vi-VN');
        }, 1000);

        let billItems = [];

        function addToPosBill(pId, pName, price, image) {
            const selectEl = document.getElementById('var_select_' + pId);
            const opt = selectEl.options[selectEl.selectedIndex];
            const vId = opt.value;
            const size = opt.getAttribute('data-size');
            const color = opt.getAttribute('data-color');
            const stock = parseInt(opt.getAttribute('data-stock')) || 0;

            const existing = billItems.find(i => i.pId === pId && i.size === size && i.color === color);
            if (existing) {
                existing.quantity += 1;
            } else {
                billItems.push({
                    pId, vId, pName, size, color, price, quantity: 1, image
                });
            }
            renderBill(true);
        }

        function updateBillItemQty(index, delta) {
            billItems[index].quantity += delta;
            if (billItems[index].quantity <= 0) {
                billItems.splice(index, 1);
            }
            renderBill(false);
        }

        function removeBillItem(index) {
            billItems.splice(index, 1);
            renderBill(false);
        }

        function clearPosBill() {
            billItems = [];
            renderBill(false);
        }

        function renderBill(shouldScrollBottom = false) {
            const container = document.getElementById('posBillContainer');
            const badge = document.getElementById('posItemCountBadge');
            let totalQty = 0;
            billItems.forEach(i => totalQty += i.quantity);
            if (badge) {
                badge.innerText = totalQty + ' món';
            }

            if (billItems.length === 0) {
                container.innerHTML = `
                    <div id="emptyBillNotice" style="text-align: center; color: var(--text-muted); padding: 3rem 1rem;">
                        <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">🛒</div>
                        <p style="font-size: 0.875rem;">Chưa có sản phẩm nào trong hóa đơn.<br>Nhấp chọn sản phẩm bên trái để bắt đầu bán.</p>
                    </div>`;
                document.getElementById('posSubmitBtn').disabled = true;
                recalcBill();
                return;
            }

            document.getElementById('posSubmitBtn').disabled = false;
            let html = '';
            billItems.forEach((item, idx) => {
                const sub = item.price * item.quantity;
                const imgTag = item.image ? '<img src="' + item.image + '" alt="" style="width: 38px; height: 38px; object-fit: cover; border-radius: 4px; border: 1px solid var(--border); flex-shrink: 0;">' : '';
                html += '<div class="pos-cart-row">' +
                    '<div style="display: flex; align-items: center; gap: 0.6rem; min-width: 0;">' +
                        imgTag +
                        '<div style="min-width: 0; flex: 1;">' +
                            '<div style="font-weight: 700; font-size: 0.85rem; color: var(--primary-dark); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="' + item.pName + '">' + item.pName + '</div>' +
                            '<div style="font-size: 0.75rem; color: var(--text-muted);">Size: <b>' + item.size + '</b> | Màu: <b>' + item.color + '</b></div>' +
                            '<input type="hidden" name="productId" value="' + item.pId + '">' +
                            '<input type="hidden" name="variantId" value="' + item.vId + '">' +
                            '<input type="hidden" name="size" value="' + item.size + '">' +
                            '<input type="hidden" name="color" value="' + item.color + '">' +
                            '<input type="hidden" name="quantity" value="' + item.quantity + '">' +
                        '</div>' +
                    '</div>' +
                    '<div class="quantity-control" style="justify-self: center;">' +
                        '<button type="button" onclick="updateBillItemQty(' + idx + ', -1)">-</button>' +
                        '<input type="text" value="' + item.quantity + '" readonly>' +
                        '<button type="button" onclick="updateBillItemQty(' + idx + ', 1)">+</button>' +
                    '</div>' +
                    '<div style="font-weight: 700; font-size: 0.85rem; text-align: right; color: var(--danger);">' +
                        sub.toLocaleString('vi-VN') + ' ₫' +
                    '</div>' +
                    '<button type="button" onclick="removeBillItem(' + idx + ')" style="background:none; border:none; color:var(--danger); cursor:pointer; font-size: 1rem; font-weight: bold; line-height: 1; padding: 2px 4px;" title="Xóa món">✕</button>' +
                '</div>';
            });
            container.innerHTML = html;
            recalcBill();
            if (shouldScrollBottom) {
                container.scrollTop = container.scrollHeight;
            }
        }

        function recalcBill() {
            let subtotal = 0;
            billItems.forEach(i => subtotal += i.price * i.quantity);
            const discount = parseFloat(document.getElementById('posDiscount').value) || 0;
            const finalTotal = Math.max(0, subtotal - discount);

            document.getElementById('posSubtotalText').innerText = subtotal.toLocaleString('vi-VN') + ' ₫';
            document.getElementById('posFinalTotalText').innerText = finalTotal.toLocaleString('vi-VN') + ' ₫';

            const cashGivenInput = document.getElementById('cashGiven');
            if (parseFloat(cashGivenInput.value) === 0 || cashGivenInput.value === '') {
                cashGivenInput.value = finalTotal;
            }
            calcChange();
        }

        function calcChange() {
            let subtotal = 0;
            billItems.forEach(i => subtotal += i.price * i.quantity);
            const discount = parseFloat(document.getElementById('posDiscount').value) || 0;
            const finalTotal = Math.max(0, subtotal - discount);

            const given = parseFloat(document.getElementById('cashGiven').value) || 0;
            const change = Math.max(0, given - finalTotal);
            document.getElementById('cashChangeText').innerText = change.toLocaleString('vi-VN') + ' ₫';
        }

        function togglePayMode(mode) {
            const calcBox = document.getElementById('cashCalcBox');
            if (mode === 'TRANSFER') {
                calcBox.style.display = 'none';
            } else {
                calcBox.style.display = 'block';
            }
        }

        function filterPosProducts() {
            const q = document.getElementById('posSearch').value.toLowerCase();
            const cards = document.querySelectorAll('.pos-item-card');
            cards.forEach(card => {
                const name = card.getAttribute('data-name');
                card.style.display = name.includes(q) ? 'flex' : 'none';
            });
        }

        function filterCategory(catId, chip) {
            document.querySelectorAll('.pos-chip').forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            const cards = document.querySelectorAll('.pos-item-card');
            cards.forEach(card => {
                if (catId === 'ALL' || card.getAttribute('data-cat') === catId) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        function closeReceiptModal() {
            const m = document.getElementById('receiptModal');
            if (m) m.style.display = 'none';
            window.location.href = '${pageContext.request.contextPath}/pos';
        }

        // F9 shortcut for POS checkout
        document.addEventListener('keydown', function(e) {
            if (e.key === 'F9') {
                e.preventDefault();
                const btn = document.getElementById('posSubmitBtn');
                if (btn && !btn.disabled) {
                    document.getElementById('posCheckoutForm').submit();
                }
            }
        });

        // Draggable Resizer between Catalog and Bill Panel (Thanh kéo co giãn độ rộng)
        (function() {
            const resizer = document.getElementById('posResizer');
            const rightPanel = document.getElementById('posCartPanel');
            const container = document.getElementById('posContainer');
            if (!resizer || !rightPanel || !container) return;

            let isResizing = false;

            resizer.addEventListener('mousedown', function(e) {
                isResizing = true;
                resizer.classList.add('dragging');
                document.body.style.cursor = 'col-resize';
                document.body.style.userSelect = 'none';
            });

            document.addEventListener('mousemove', function(e) {
                if (!isResizing) return;
                const containerRect = container.getBoundingClientRect();
                const newWidth = containerRect.right - e.clientX;
                if (newWidth >= 380 && newWidth <= (containerRect.width - 320)) {
                    rightPanel.style.width = newWidth + 'px';
                }
            });

            document.addEventListener('mouseup', function() {
                if (isResizing) {
                    isResizing = false;
                    resizer.classList.remove('dragging');
                    document.body.style.cursor = '';
                    document.body.style.userSelect = '';
                }
            });
        })();
    </script>
</body>
</html>
