package com.model2.mvc.web.product;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

//==> 상품관리 Controller
@Controller
@RequestMapping("/product/*")
public class ProductController {

	/// Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	// setter Method 구현 않음

	public ProductController() {
		System.out.println(this.getClass());
	}

	// ==> classpath:config/common.properties , classpath:config/commonservice.xml
	// 참조 할것
	// ==> 아래의 두개를 주석을 풀어 의미를 확인 할것
	@Value("#{commonProperties['pageUnit']}")
	// @Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;

	@Value("#{commonProperties['pageSize']}")
	// @Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;

	// @RequestMapping("/addProduct.do")
	@RequestMapping(value = "addProduct", method = RequestMethod.POST)
	public String addProduct(@ModelAttribute("product") Product product) throws Exception {

		System.out.println("/addProduct");

		String manuDate = product.getManuDate();
		//String replaceManuDate = manuDate.replace("-", "");
		String replaceManuDate = manuDate.replace("/", "");

		product.setManuDate(replaceManuDate);

		// Business Logic
		productService.addProduct(product);

		return "forward:/product/getProduct.jsp";
	}

	// @RequestMapping("/getProduct.do")
	@RequestMapping(value = "getProduct")
	public String getProduct(@RequestParam("prodNo") int prodNo, @RequestParam("menu") String menu, Model model,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		System.out.println("/getProduct");

		// Business Logic
		Product product = productService.getProduct(prodNo);

		// Model 과 View 연결
		model.addAttribute("product", product);

		if (menu.equals("manage")) {
			return "redirect:/product/updateProductView?prodNo=" + prodNo + "&menu=" + menu;
		} else {

			String history = "";

			Cookie[] cookies = request.getCookies();

			if (cookies != null && cookies.length > 0) {

				for (int i = 0; i < cookies.length; i++) {

					Cookie cookie = cookies[i];

					if (cookie.getName().equals("history")) {
						history = cookie.getValue();

					}
				}
			}

			HashSet<String> historySet = new HashSet<String>();
			historySet.addAll(Arrays.asList(history.split(",")));
			System.out.println("history_point1" + historySet);
			historySet.add(prodNo+"");

			ArrayList<String> tempList = new ArrayList<String>(historySet);
			System.out.println("history_point2" + tempList);
			Collections.sort(tempList);
			System.out.println("history_point3" + tempList);

			history = "";
			for (String itemNum : tempList) {
				history += ","+ itemNum;
			}

			Cookie cookie = new Cookie("history", history);
			cookie.setPath("/");
			response.addCookie(cookie);

			return "forward:/product/getProductDetail.jsp";

		}
	}

	// @RequestMapping("/updateProductView.do")
	@RequestMapping(value = "updateProductView")
	public String updateProductView(@RequestParam("prodNo") int prodNo, @RequestParam("menu") String menu, Model model)
			throws Exception {

		System.out.println("/updateProductView");

		// Business Logic
		Product product = productService.getProduct(prodNo);
		
		// Model 과 View 연결
		model.addAttribute("product", product);

		return "forward:/product/updateProduct.jsp?menu=" + menu;

	}

	// @RequestMapping("/updateProduct.do")
	@RequestMapping(value = "updateProduct")
	public String updateProduct(@RequestParam("prodNo") int prodNo, @RequestParam("menu") String menu,
			@ModelAttribute("product") Product product) throws Exception {

		System.out.println("/updateProduct");

		product.setProdNo(prodNo);
		productService.updateProduct(product);

		return "redirect:/product/getProduct?prodNo=" + prodNo + "&menu=yes";

	}

	// @RequestMapping("/listProduct.do")
	@RequestMapping(value = "listProduct")
	public String listProduct(@ModelAttribute("search") Search search, Model model, HttpServletRequest request)
			throws Exception {

		System.out.println("/listProduct");

		if (search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);

		// Business logic 수행
		Map<String, Object> map = productService.getProductList(search);

		Page resultPage = new Page(search.getCurrentPage(), ((Integer) map.get("totalCount")).intValue(), pageUnit,
				pageSize);
		System.out.println(resultPage);

		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);

		return "forward:/product/listProduct.jsp";
	}
}