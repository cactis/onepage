# -*- encoding : utf-8 -*-
class Jspice < Snippet

  def content
    read_attribute(:content) ||
<<-eos


<script>

</script>
eos

  end

end

