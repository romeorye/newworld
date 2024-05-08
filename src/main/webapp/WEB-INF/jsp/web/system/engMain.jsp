<%--
/**------------------------------------------------------------------------------
 * NAME : main.jsp
 * DESC : 
 * VER  : v1.0
 * PROJ : LG CNS WINS UPGRADE PROJECT
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.05.27   �����		 WINS UPGRADE PROJECT			  
 *------------------------------------------------------------------------------*/
--%>  
<%@ page language ="java"  pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>								
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="<%=cssPath%>/common.css" type="text/css" />
<script type="text/javascript">

</script>
<head>
<title>WINS MAIN</title>
</head>
<form name="aform" id="aform" method="post">
	<div class="contents">
		<div class="userGroupArea">
			<div class="groupTop">
				<div class="groupColumn">
					<dl class="groupInner">
						<dt>
							<h3>�ð��� ����</h3>
							<a href="#none">��������</a>
						</dt>
						<dd>
							<strong>�Ͽ�¡��ũ(��)</strong>
							<span>ȫ�浿</span>
							<p>����� �߱� �߸��� 419�����帲���ǽ� Ÿ��</p>
						</dd>
					</dl>
					<div class="columnRowRight">
						<ul class="groupInfo">
							<li>
								<h4>
									�ð� �η� <br />
									��Ȳ
								</h4>
								<a href="#none">Ȱ������</a>
							</li>
							<li>
								<span>���Ϲ�ġ�ο�/��</span>
								<strong>0/0</strong>
							</li>
							<li>
								<span>�� ����ο�/��</span>
								<strong>0/0</strong>
							</li>
							<li>
								<span>������/��</span>
								<strong>25%</strong>
							</li>
						</ul>
						
					</div>
					<div class="columnRowRight">
						<ul class="groupInfo">
							<li>
								<h4>
									���� �ð� <br />
									���� ��Ȳ
								</h4>
							</li>
							<li>
								<span>�������ð���</span>
								<strong>5</strong>
							</li>
							<li>
								<span>�ð���</span>
								<strong>8</strong>
							</li>
							<li>
								<span>�ð��Ϸ�</span>
								<strong>0</strong>
							</li>
							<li>
								<span>�̽�����</span>
								<strong>12</strong>
							</li>
						</ul>
					</div>
				</div>
				<!-- // groupColumn -->


				<div class="groupColumn">
					<div class="columnRowLeft">
						<ul class="groupInfo">
							<li>
								<h4>
									�ð��η� <br />
									��Ȳ
								</h4>
							</li>
							<li>
								<span>�űԽð��ֹ�</span>
								<strong>0</strong>
							</li>
							<li>
								<span>�ð��ֹ�����</span>
								<strong>2</strong>
							</li>
							<li>
								<span>�ð��ֹ�����/���</span>
								<strong>2/3</strong>
							</li>
							<li>
								<span>�Ϸ���ο�û</span>
								<strong>0</strong>
							</li>
							<li>
								<span>�Ϸ����</span>
								<strong>5</strong>
							</li>
							<li class="pointBg">
								<span>�Ϸ���ιݷ�</span>
								<strong>25</strong>
							</li>
						</ul>
					</div>
					<div class="columnRowRight">
						<ul class="groupInfo">
							<li>
								<h4>
									������Ȳ <br />
									(QCS)
								</h4>
							</li>
							<li>
								<span>���Ϲ�������(��/��)</span>
								<strong>5/0</strong>
							</li>
							<li>
								<span>�ݿ���������(��/��)</span>
								<strong>5/20</strong>
							</li>
						</ul>
					</div>
				</div>
				<!-- // groupColumn -->


				<div class="groupColumn">
					<div class="columnRowLeft">
						<ul class="groupInfo type02">
							<li>
								<h4>
									������Ȳ <br />
									<span class="pointB">����26�� ~ ���25��</span>
								</h4>
							</li>
							<li>
								<span>���꿹�� �ݾ�(��/��)</span>
								<strong>
									<span>5/</span>
									258,600,000
								</strong>
							</li>
							<li>
								<span>����Ȯ�� �ݾ�(��/��)</span>
								<strong>
									<span>4/</span>
									258,600
								</strong>
							</li>
							<li>
								<span>���� ������ �ܾ�(��/��)</span>
								<strong>
									<span>12/</span>
									258,600
								</strong>
							</li>
							<li>
								<span>������ �ܾ�(��/��)</span>
								<strong>
									<span>0/</span>
									258,600
								</strong>
							</li>
						</ul>
						<p class="desc">
							<strong>������ݾ�</strong> : '13��~���� �������������� ����
						</p>
					</div>
					<div class="columnRowRight">
						<ul class="groupInfo type02">
							<li>
								<h4>
									�ð��� �� <br />
									(�ݿ�)
								</h4>
							</li>
							<li>
								<span>���Ϲ�������(��/��)</span>
								<strong>5/0</strong>
							</li>
							<li>
								<span>�ݿ���������(��/��)</span>
								<strong>0/0</strong>
							</li>
						</ul>
					</div>
				</div>
				<!-- // groupColumn -->
			</div>
			<!-- // groupTop -->


			<div class="groupBot">
				<div class="notice-area">
					<div class="tit-area">
						<h3>Notice</h3>
						<a href="#none" class="notice-more"></a>
					</div>
					<div class="notice-top">
						<h4><a href="#none">���θ� ���� ǰ�������� ���� ������ ����</a></h4>
						<span class="date">2016-05-30</span>
						<p class="desc ellipsis">
							<a href="#none">��������� ��� ���ϻ���� ��Ģ���� �ϰ� ������, ��� ��
							���� �ָ����� ����� ������ �� ������ ����� ������ ���Ͽ���������������������������������������</a>
						</p>
					</div>
					<ul class="notice-list">
						<li>
							<a href="#none">���θ� ���� ǰ�������� ���� ������ ���� �ڼ��� ���θ� ���� ǰ�������� ���� ������ ���� �ڼ��� </a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">���庻�� ����</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">������ ���� ������ Ǯ�� �����ǰ�</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">�ΰ�_â������ �̿��� ���� ��ģ��</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">�Ŀ����� ���� �Ϻκ��濡 ���� �������� ȥ�����</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">������ ���� ������ Ǯ�� �����ǰ�</a>
							<span class="date">2016-05-30</span>
						</li>
						<li>
							<a href="#none">������ ���� ������ Ǯ�� �����ǰ�</a>
							<span class="date">2016-05-30</span>
						</li>
					</ul>
				</div>
				<div class="groupRight">
					<div class="customer">
						<h3>����Ÿ</h3>
						<strong>02-2039-7185</strong>
						<p>
							���� : 09:00 ~ 18:00 <br />
							��,�Ͽ��� �� ������ �޹�
						</p>
					</div>
					<ul class="groupLink">
						<li>
							<a href="#none">
								<img src="../resource/images/common/group_link01.png" alt="" />
							</a>
						</li>
						<li>
							<a href="#none">
								<img src="../resource/images/common/group_link02.png" alt="" />
							</a>
						</li>
						<li>
							<a href="#none">
								<img src="../resource/images/common/group_link03.png" alt="" />
							</a>
						</li>
					</ul>
				</div>
			</div>
			<!-- // groupBot -->


		</div>	
	</div><!-- //contents -->
</form>	
</html>