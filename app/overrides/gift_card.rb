Deface::Override.new(virtual_path: "spree/checkout/edit",
                     insert_after: "#checkout-summary",
                     partial: "spree/overrides/add_gift_code_field",
                     name: "add_gift_code_field")